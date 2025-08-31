//
//  temp4.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//


import Foundation
import Combine

final class AllUserListUsecase {
    private var currentPage: Int = 1
    private var isEnd: Bool = false
    private var currentQuery: String = ""
    
    private let repository: UserListRepositoryProtocol
    
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        repository.favoriteUsersPublisher
    }
    
    init(repository: UserListRepositoryProtocol) {
        self.repository = repository
    }
}

extension AllUserListUsecase: AllUserListUsecaseProtocol {
    func searchUsers(query: String, perPage: Int) async throws -> [GitHubUserEntity] {
        currentQuery = query
        resetPaging()
        return try await loadNextPage(perPage: perPage)
    }
    
    func loadNextPage(perPage: Int) async throws -> [GitHubUserEntity] {
        guard !isEnd else { return [] }
        let (remoteUsers, totalCount) = try await repository.searchUsers(
            query: currentQuery,
            page: currentPage,
            perPage: perPage
        )
        
        currentPage += 1
        if (currentPage - 1) * perPage >= totalCount { isEnd = true }
        return remoteUsers
    }

    @MainActor
    func toggleFavorite(_ user: GitHubUserEntity) async throws {
        if user.isFavorite {
            try repository.removeFavorite(user)
        } else {
            try repository.addFavorite(user)
        }
    }
    
    private func resetPaging() {
        currentPage = 1
        isEnd = false
    }
}
