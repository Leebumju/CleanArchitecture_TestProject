//
//  temp3.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

protocol UserListRepositoryProtocol: AnyObject {
    func searchUsers(with query: String) async throws -> [GitHubUserEntity]
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> { get }
    func getFavoriteUsers() -> [GitHubUserEntity]
    func addFavorite(_ user: GitHubUserEntity) throws
    func removeFavorite(_ user: GitHubUserEntity) throws
}
