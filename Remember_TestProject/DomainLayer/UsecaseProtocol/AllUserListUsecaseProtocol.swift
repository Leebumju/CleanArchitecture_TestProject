//
//  temp5.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

protocol AllUserListUsecaseProtocol: BaseUsecaseProtocol {
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> { get }
    
    func searchUsers(query: String, perPage: Int) async throws -> [GitHubUserEntity]
    func loadNextPage(perPage: Int) async throws -> [GitHubUserEntity]
    func toggleFavorite(_ user: GitHubUserEntity) throws
}
