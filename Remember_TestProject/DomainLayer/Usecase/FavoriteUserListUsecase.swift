//
//  FavoriteUserListUsecase.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine

final class FavoriteUserListUsecase {
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        repository.favoriteUsersPublisher
    }
    private(set) var errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: UserListRepositoryProtocol
    
    init(repository: UserListRepositoryProtocol) {
        self.repository = repository
    }
}

extension FavoriteUserListUsecase: FavoriteUserListUsecaseProtocol {
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
