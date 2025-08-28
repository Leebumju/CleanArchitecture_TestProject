//
//  FavoriteUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Combine

final class FavoriteUserListViewModel: BaseViewModel {
    private let usecase: FavoriteUserListUsecaseProtocol
    
    private let favoriteUsersSubject = CurrentValueSubject<[GitHubUserEntity], Never>([])
    var favoriteUsersPublisher: AnyPublisher<[GitHubUserEntity], Never> {
        favoriteUsersSubject.eraseToAnyPublisher()
    }
    var favoriteUsers: [GitHubUserEntity] {
        favoriteUsersSubject.value
    }
    
    init(usecase: FavoriteUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        usecase.favoriteUsersPublisher
            .map { $0.sorted { $0.login.lowercased() < $1.login.lowercased() } }
            .sink { [weak self] users in
                self?.favoriteUsersSubject.send(users)
            }
            .store(in: &cancelBag)
    }
    
    func toggleFavorite(_ user: GitHubUserEntity) throws {
        try usecase.toggleFavorite(user)
    }
}
