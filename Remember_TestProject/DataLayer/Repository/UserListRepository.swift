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
    }
}

extension UserListRepository: UserListRepositoryProtocol {
    func searchUsers(with query: String) async throws -> [GitHubUserEntity] {
        let response = try await remoteDataFetcher.searchUsers(with: query)
        return GitHubUserMapper.gitHubUserResponsetoEntity(response)
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
