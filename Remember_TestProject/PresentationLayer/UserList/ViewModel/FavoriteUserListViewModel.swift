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
    
    private let favoriteUsersSectionsSubject = CurrentValueSubject<[FavoriteUserSection], Never>([])
    var favoriteUsersSectionsPublisher: AnyPublisher<[FavoriteUserSection], Never> {
        favoriteUsersSectionsSubject.eraseToAnyPublisher()
    }
    var favoriteUsers: [FavoriteUserSection] {
        favoriteUsersSectionsSubject.value
    }
    
    init(usecase: FavoriteUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        usecase.favoriteUsersPublisher
            .map { users -> [FavoriteUserSection] in
                let sorted = users.sorted { $0.login.lowercased() < $1.login.lowercased() }
                let grouped = Dictionary(grouping: sorted) { String($0.login.prefix(1)).uppercased() }
                return grouped.keys.sorted().map { key in
                    FavoriteUserSection(title: key, users: grouped[key] ?? [])
                }
            }
            .sink { [weak self] sections in
                self?.favoriteUsersSectionsSubject.send(sections)
            }.store(in: &cancelBag)
    }
    
    func toggleFavorite(_ user: GitHubUserEntity) throws {
        try usecase.toggleFavorite(user)
    }
}
