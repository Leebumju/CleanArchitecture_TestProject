//
//  UserListRepository.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine

final class UserListRepository {
    private(set) var favoriteUsersSubjectSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        favoriteUsersSubjectSubject.eraseToAnyPublisher()
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
        return GitHubUserMapper.gitHubUsertoEntity(response)
    }
}
