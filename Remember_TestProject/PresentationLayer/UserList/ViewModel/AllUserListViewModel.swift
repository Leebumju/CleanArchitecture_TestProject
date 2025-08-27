//
//  AllUserListViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

final class AllUserListViewModel: BaseViewModel {
    private let usecase: AllUserListUsecaseProtocol
    
    init(usecase: AllUserListUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
    }
}
