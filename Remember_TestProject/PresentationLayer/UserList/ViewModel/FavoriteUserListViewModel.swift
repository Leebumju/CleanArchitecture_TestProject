//
//  FavoriteUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

final class FavoriteUserListViewModel: BaseViewModel {
    private let usecase: FavoriteUserListUsecaseProtocol
    
    init(usecase: FavoriteUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
    }
}
