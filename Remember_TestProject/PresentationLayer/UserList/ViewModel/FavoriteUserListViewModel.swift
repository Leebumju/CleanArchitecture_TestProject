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
    // MARK: - Properties
    private let usecase: FavoriteUserListUsecaseProtocol
    private var allFavoriteUsers: [GitHubUserEntity] = []
    private var currentSearchKeyword: String = ""
    
    // MARK: - Publishers
    private let favoriteUsersSectionsSubject = CurrentValueSubject<[FavoriteUserSection], Never>([])
    var favoriteUsersSectionsPublisher: AnyPublisher<[FavoriteUserSection], Never> {
        favoriteUsersSectionsSubject.eraseToAnyPublisher()
    }
    var favoriteUsers: [FavoriteUserSection] { favoriteUsersSectionsSubject.value }
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }
    
    // MARK: - Init
    init(usecase: FavoriteUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        bindFavorites()
    }
    
    // MARK: - Binding
    private func bindFavorites() {
        usecase.favoriteUsersPublisher
            .sink { [weak self] users in
                guard let self = self else { return }
                self.allFavoriteUsers = users.sorted {
                    $0.login.localizedCaseInsensitiveCompare($1.login) == .orderedAscending
                }
                self.updateSections()
            }
            .store(in: &cancelBag)
    }
    
    // MARK: - Public Methods
    func searchUsers(keyword: String) {
        currentSearchKeyword = keyword
        updateSections()
    }
    
    func toggleFavorite(_ user: GitHubUserEntity) {
        Task {
            do {
                try await usecase.toggleFavorite(user)
            } catch {
                errorSubject.send(error)
            }
        }
    }
    
    // MARK: - Helpers
    private func updateSections() {
        let filteredUsers = currentSearchKeyword.isEmpty
            ? allFavoriteUsers
            : allFavoriteUsers.filter {
                $0.login.localizedCaseInsensitiveContains(currentSearchKeyword)
            }
        
        let grouped = Dictionary(grouping: filteredUsers) { String($0.login.prefix(1)).uppercased() }
        let sections = grouped.keys.sorted().map { key in
            FavoriteUserSection(title: key, users: grouped[key]!)
        }
        
        favoriteUsersSectionsSubject.send(sections)
    }
}
