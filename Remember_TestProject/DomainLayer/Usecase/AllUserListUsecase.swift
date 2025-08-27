//
//  temp4.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//


import Foundation
import Combine

final class AllUserListUsecase {
    private(set) var errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: UserListRepositoryProtocol
    
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        repository.favoriteUsersPublisher
    }
    
    init(repository: UserListRepositoryProtocol) {
        self.repository = repository
    }
}

extension AllUserListUsecase: AllUserListUsecaseProtocol {
    func searchUsers(with query: String) async throws -> [GitHubUserEntity] {
        let remoteUsers = try await repository.searchUsers(with: query)
        let favorites = repository.getFavoriteUsers()
        let favoriteIds = Set(favorites.map { $0.id })

        return remoteUsers.map {
            var u = $0
            u.isFavorite = favoriteIds.contains(u.id)
            return u
        }
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
}
