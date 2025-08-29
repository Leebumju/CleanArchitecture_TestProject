//
//  FavoriteUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

struct FavoriteUserSection {
    let title: String
    let users: [GitHubUserEntity]
}

final class FavoriteUserListViewModel: BaseViewModel {
    private let usecase: FavoriteUserListUsecaseProtocol
    
    private var allFavoriteUsers: [GitHubUserEntity] = []
    private var currentSearchKeyword: String = ""
    
    private let favoriteUsersSectionsSubject = CurrentValueSubject<[FavoriteUserSection], Never>([])
    var favoriteUsersSectionsPublisher: AnyPublisher<[FavoriteUserSection], Never> {
        favoriteUsersSectionsSubject.eraseToAnyPublisher()
    }
    var favoriteUsers: [FavoriteUserSection] {
        favoriteUsersSectionsSubject.value
    }
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(usecase: FavoriteUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        usecase.favoriteUsersPublisher
            .sink { [weak self] users in
                guard let self = self else { return }
                self.allFavoriteUsers = users.sorted { $0.login.localizedCaseInsensitiveCompare($1.login) == .orderedAscending }
                self.updateSections()
            }.store(in: &cancelBag)
    }
    
    func searchUsers(keyword: String) {
        currentSearchKeyword = keyword
        updateSections()
    }
    
    func toggleFavorite(_ user: GitHubUserEntity) {
        do {
            try usecase.toggleFavorite(user)
        } catch {
            errorSubject.send(error)
        }
    }
    
    private func updateSections() {
        let filtered: [GitHubUserEntity]
        if currentSearchKeyword.isEmpty {
            filtered = allFavoriteUsers
        } else {
            filtered = allFavoriteUsers.filter { $0.login.localizedCaseInsensitiveContains(currentSearchKeyword) }
        }
        
        let grouped = Dictionary(grouping: filtered) { String($0.login.prefix(1)).uppercased() }
        let sections = grouped.keys.sorted().map { key in
            FavoriteUserSection(title: key, users: grouped[key]!)
        }
        favoriteUsersSectionsSubject.send(sections)
    }
}
