//
//  Injector.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Swinject

struct Injector {
    private init() {}
    
    static let shared: Container = {
        let container = Container()
        
        container.register(RemoteDataFetchable.self) { _ in
            return RemoteDataFetcher()
        }
        
        container.register(LocalDataFetchable.self) { _ in
            return LocalDataFetcher()
        }
        
        container.register(UserListRepositoryProtocol.self) { resolver in
            let repository = UserListRepository(
                remoteDataFetcher: resolver.resolve(RemoteDataFetchable.self)!,
                localDataFetcher: resolver.resolve(LocalDataFetchable.self)!
            )
            return repository
        }.inObjectScope(.container)
        
        container.register(AllUserListUsecaseProtocol.self) { resolver in
            let usecase = AllUserListUsecase(repository: resolver.resolve(UserListRepositoryProtocol.self)!)
            return usecase
        }
        
        container.register(FavoriteUserListUsecaseProtocol.self) { resolver in
            let usecase = FavoriteUserListUsecase(repository: resolver.resolve(UserListRepositoryProtocol.self)!)
            return usecase
        }
        
        return container
    }()
}
