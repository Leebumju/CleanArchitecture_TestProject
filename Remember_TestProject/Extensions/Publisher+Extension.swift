//
//  Publisher+Extension.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine

extension Publisher {
    func droppedSink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        return self
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: receiveValue)
    }
    
    func mainSink(receiveValue: @escaping ((Output) -> Void)) -> AnyCancellable {
        return self
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: receiveValue)
    }
}
