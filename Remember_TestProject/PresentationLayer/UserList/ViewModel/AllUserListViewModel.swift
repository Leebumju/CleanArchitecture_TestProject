//
//  AllUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

final class AllUserListViewModel: BaseViewModel {
//    private(set) var currentPage: Int = 1
//    private(set) var isLoading: Bool = false
//    private(set) var isEnd: Bool = false
//    private(set) var storedKeyword: String = ""
//    
    private(set) var allSearchedUsers: [GitHubUserEntity] = []
    private let searchedUsersSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    var searchedUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        return searchedUsersSubject.eraseToAnyPublisher()
    }
    
    private let usecase: AllUserListUsecaseProtocol

    init(usecase: AllUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
    }

    func searchUsers(with query: String) async throws {
        allSearchedUsers = try await usecase.searchUsers(with: query)
        searchedUsersSubject.send(allSearchedUsers)
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
