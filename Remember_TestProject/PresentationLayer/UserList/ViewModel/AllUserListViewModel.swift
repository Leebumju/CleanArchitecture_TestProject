//
//  AllUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

final class AllUserListViewModel: BaseViewModel {
    private var favoriteUsers: [GitHubUserEntity] = []
    // MARK: - Publishers
    private let searchedUsersSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    var searchedUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        searchedUsersSubject.eraseToAnyPublisher()
    }
    var searchedUsers: [GitHubUserEntity] {
        searchedUsersSubject.value
    }
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    private(set) var isPaging: Bool = false
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private let usecase: AllUserListUsecaseProtocol
    
    // MARK: - Init
    init(usecase: AllUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        bindFavorites()
    }
    
    // MARK: - Bind Favorites
    private func bindFavorites() {
        usecase.favoriteUsersPublisher
            .sink { [weak self] favorites in
                guard let self = self else { return }
                self.favoriteUsers = favorites
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
    
    // MARK: - Search Users
    func searchUsers(keyword: String) {
        guard !isLoadingSubject.value else { return }
        isLoadingSubject.send(true)
        isPaging = false
        
        Task {
            defer { isLoadingSubject.send(false) }
            do {
                let users = try await usecase.searchUsers(query: keyword, perPage: 30)
                let updatedUsers = updateFavorites(for: users)
                searchedUsersSubject.send(updatedUsers)
            } catch {
                errorSubject.send(error)
            }
        }
    }
    
    // MARK: - Load Next Page
    func loadNextPage() {
        guard !isLoadingSubject.value else { return }
        isLoadingSubject.send(true)
        isPaging = true

        Task {
            defer { isLoadingSubject.send(false) }
            do {
                let users = try await usecase.loadNextPage(perPage: 30)
                let updatedUsers = updateFavorites(for: searchedUsers + users)
                searchedUsersSubject.send(updatedUsers)
            } catch {
                errorSubject.send(error)
            }
        }
    }
    
    // MARK: - Toggle Favorite
    func toggleFavorite(_ user: GitHubUserEntity) {
        do {
            try usecase.toggleFavorite(user)
        } catch {
            errorSubject.send(error)
        }
    }
    
    private func updateFavorites(for users: [GitHubUserEntity]) -> [GitHubUserEntity] {
        let favoriteIds = Set(favoriteUsers.map { $0.id })
        return users.map { user -> GitHubUserEntity in
            var u = user
            u.isFavorite = favoriteIds.contains(u.id)
            return u
        }
    }
}
