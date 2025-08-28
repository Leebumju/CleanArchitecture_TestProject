//
//  AllUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

final class AllUserListViewModel: BaseViewModel {
    private var isLoading: Bool = false
    
    private let searchedUsersSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    var searchedUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        searchedUsersSubject.eraseToAnyPublisher()
    }
    var searchedUsers: [GitHubUserEntity] { searchedUsersSubject.value }
    
    private let usecase: AllUserListUsecaseProtocol
    
    init(usecase: AllUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        bindFavorites()
    }
    
    private func bindFavorites() {
        usecase.favoriteUsersPublisher
            .sink { [weak self] favorites in
                guard let self = self else { return }
                let favoriteIds = Set(favorites.map { $0.id })
                let updated = self.searchedUsers.map { user -> GitHubUserEntity in
                    var u = user
                    u.isFavorite = favoriteIds.contains(u.id)
                    return u
                }
                self.searchedUsersSubject.send(updated)
            }
            .store(in: &cancelBag)
    }
    
    func searchUsers(with query: String) async throws {
        let users = try await usecase.searchUsers(query: query, perPage: 30)
        searchedUsersSubject.send(users)
    }
    
    func loadNextPage() async throws {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        let users = try await usecase.loadNextPage(perPage: 30)
        searchedUsersSubject.send(searchedUsers + users)
    }
    
    func toggleFavorite(_ user: GitHubUserEntity) throws {
        try usecase.toggleFavorite(user)
    }
}
