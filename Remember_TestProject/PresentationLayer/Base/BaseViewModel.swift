//
//  BaseViewModel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine

class BaseViewModel {
    var cancelBag = Set<AnyCancellable>()
    private let usecase: BaseUsecaseProtocol
    
    init(usecase: BaseUsecaseProtocol) {
        self.usecase = usecase
    }
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return usecase.getErrorSubject()
    }
    
    deinit {
        print("⚡ deinit ---> \(self)")
    }
}
