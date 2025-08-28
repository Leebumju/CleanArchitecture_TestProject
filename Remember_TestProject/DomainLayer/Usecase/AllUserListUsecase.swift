//
//  temp4.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//


import Foundation
import Combine

final class AllUserListUsecase {
    private var currentPage: Int = 1
    private var isEnd: Bool = false
    private var storedQuery: String = ""
    
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        repository.favoriteUsersPublisher
    }
    private(set) var errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: UserListRepositoryProtocol
    
    init(repository: UserListRepositoryProtocol) {
        self.repository = repository
    }
}

extension AllUserListUsecase: AllUserListUsecaseProtocol {
    func searchUsers(query: String, perPage: Int) async throws -> [GitHubUserEntity] {
        storedQuery = query
        resetPaging()
        return try await loadNextPage(perPage: perPage)
    }
    
    func loadNextPage(perPage: Int) async throws -> [GitHubUserEntity] {
        guard !isEnd else { return [] }
        
        let (remoteUsers, totalCount) = try await repository.searchUsers(query: storedQuery, page: currentPage, perPage: perPage)
        let favorites = repository.getFavoriteUsers()
        let favoriteIds = Set(favorites.map { $0.id })
        
        let mappedUsers = remoteUsers.map { user -> GitHubUserEntity in
            var u = user
            u.isFavorite = favoriteIds.contains(u.id)
            return u
        }
        
        currentPage += 1
        if (currentPage - 1) * perPage >= totalCount {
            isEnd = true
        }
        
        return mappedUsers
    }
    
    func toggleFavorite(_ user: GitHubUserEntity) throws {
        do {
            if user.isFavorite {
                try repository.removeFavorite(user)
            } else {
                try repository.addFavorite(user)
            }
        } catch {
            errorSubject.send(error)
            throw error
        }
    }
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private func resetPaging() {
         currentPage = 1
         isEnd = false
     }
}
