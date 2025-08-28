//
//  AllUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

final class AllUserListViewModel: BaseViewModel {
    private let searchedUsersSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    var searchedUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        return searchedUsersSubject.eraseToAnyPublisher()
    }
    var searchedUsers: [GitHubUserEntity] {
        searchedUsersSubject.value
    }
    
    private let usecase: AllUserListUsecaseProtocol

    init(usecase: AllUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
    }
    
    func searchUsers(with query: String) async throws {
        let users = try await usecase.searchUsers(with: query)
        searchedUsersSubject.send(users)
    }
    
    func toggleFavorite(_ user: GitHubUserEntity) throws {
        try usecase.toggleFavorite(user)
        var current = searchedUsersSubject.value
        if let index = current.firstIndex(where: { $0.id == user.id }) {
            current[index].isFavorite.toggle()
            searchedUsersSubject.send(current)
        }
    }
}
