//
//  temp4.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//


import Foundation
import Combine

final class AllUserListUsecase {
    private(set) var errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: UserListRepositoryProtocol
    
    init(repository: UserListRepositoryProtocol) {
        self.repository = repository
    }
}

extension AllUserListUsecase: AllUserListUsecaseProtocol {
    func searchUsers(with query: String) async throws {
        do {
            print(try await repository.searchUsers(with: query))
        } catch {
            errorSubject.send(error)
            throw error
        }
    }
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
