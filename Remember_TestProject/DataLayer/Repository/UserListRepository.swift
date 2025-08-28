//
//  UserListRepository.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine

final class UserListRepository {
    private(set) var favoriteUsersSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        favoriteUsersSubject.eraseToAnyPublisher()
    }
    
    private let remoteDataFetcher: RemoteDataFetchable
    private let localDataFetcher: LocalDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable, localDataFetcher: LocalDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
        self.localDataFetcher = localDataFetcher
        
        let favorites = localDataFetcher.fetchFavoriteUsers()
        favoriteUsersSubject.send(favorites)
    }
}

extension UserListRepository: UserListRepositoryProtocol {
    func searchUsers(query: String, page: Int, perPage: Int) async throws -> (users: [GitHubUserEntity], totalCount: Int) {
        let request: GitHubUserRequest = GitHubUserRequest(query: query,
                                                           page: page,
                                                           perPage: perPage)
        let response = try await remoteDataFetcher.searchUsers(with: request)
        let users = GitHubUserMapper.gitHubUserResponsetoEntity(response)
        let totalCount = response.totalCount ?? 0
        return (users, totalCount)
    }
    
    func addFavorite(_ user: GitHubUserEntity) throws {
        try localDataFetcher.save(user)
        let updated = localDataFetcher.fetchFavoriteUsers()
        favoriteUsersSubject.send(updated)
    }
    
    func removeFavorite(_ user: GitHubUserEntity) throws {
        try localDataFetcher.delete(user)
        let updated = localDataFetcher.fetchFavoriteUsers()
        favoriteUsersSubject.send(updated)
    }
    
    func getFavoriteUsers() -> [GitHubUserEntity] {
        favoriteUsersSubject.value
    }
}
