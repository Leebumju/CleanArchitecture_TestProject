//
//  FavoriteUserListUsecase.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine

final class FavoriteUserListUsecase {
    private(set) var errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: UserListRepositoryProtocol
    
    init(repository: UserListRepositoryProtocol) {
        self.repository = repository
    }
}

extension FavoriteUserListUsecase: FavoriteUserListUsecaseProtocol {
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
