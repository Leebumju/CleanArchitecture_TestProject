//
//  FavoriteUserListUsecaseProtocol.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

protocol FavoriteUserListUsecaseProtocol: BaseUsecaseProtocol {
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> { get }
    func toggleFavorite(_ user: GitHubUserEntity) throws
}
