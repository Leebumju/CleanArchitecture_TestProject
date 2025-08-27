//
//  UserListRepository.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation

final class UserListRepository {
    private let remoteDataFetcher: RemoteDataFetchable
    private let localDataFetcher: LocalDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable, localDataFetcher: LocalDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
        self.localDataFetcher = localDataFetcher
    }
}

extension UserListRepository: UserListRepositoryProtocol {

}
