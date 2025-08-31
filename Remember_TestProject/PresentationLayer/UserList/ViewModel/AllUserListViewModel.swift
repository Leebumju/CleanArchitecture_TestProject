//
//  AllUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

final class AllUserListViewModel: BaseViewModel {
    // MARK: - State
    private var favoriteUserIds = Set<Int>()
    private(set) var isPaging = false
    
    // MARK: - Publishers
    private let searchedUsersSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    var searchedUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        searchedUsersSubject.eraseToAnyPublisher()
    }
    var searchedUsers: [GitHubUserEntity] { searchedUsersSubject.value }
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
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
    
    // MARK: - Binding
    private func bindFavorites() {
        usecase.favoriteUsersPublisher
            .sink { [weak self] favorites in
                guard let self = self else { return }
                self.favoriteUserIds = Set(favorites.map { $0.id })
                self.sendUsers(self.searchedUsers)
            }
            .store(in: &cancelBag)
    }
    
    // MARK: - Public Methods
    func searchUsers(keyword: String) {
        guard !isLoadingSubject.value else { return }
        isLoadingSubject.send(true)
        isPaging = false
        
        Task {
            defer { isLoadingSubject.send(false) }
            do {
                let users = try await usecase.searchUsers(query: keyword, perPage: 30)
                sendUsers(users)
            } catch {
                errorSubject.send(error)
            }
        }
    }
    
    func loadNextPage() {
        guard !isLoadingSubject.value else { return }
        isLoadingSubject.send(true)
        isPaging = true

        Task {
            defer { isLoadingSubject.send(false) }
            do {
                let users = try await usecase.loadNextPage(perPage: 30)
                sendUsers(searchedUsers + users)
            } catch {
                errorSubject.send(error)
            }
        }
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
    private func sendUsers(_ users: [GitHubUserEntity]) {
        let updated = users.map { user -> GitHubUserEntity in
            var u = user
            u.isFavorite = favoriteUserIds.contains(u.id)
            return u
        }
        searchedUsersSubject.send(updated)
    }
}
