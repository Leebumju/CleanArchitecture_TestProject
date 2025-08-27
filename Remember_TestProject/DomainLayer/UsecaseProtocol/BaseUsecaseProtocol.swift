//
//  BaseUsecaseProtocol.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine

protocol BaseUsecaseProtocol: AnyObject {
    var errorSubject: PassthroughSubject<Error, Never> { get }
    func getErrorSubject() -> AnyPublisher<Error, Never>
}
