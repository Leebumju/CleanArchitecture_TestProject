//
//  Coordinator.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/26/25.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var rootViewController: UIViewController { get set }
    
    func start() -> UIViewController
    func moveTo(appFlow: Flow, userData: [String: Any]?)
}

extension Coordinator {
    var rootNavigationController: UINavigationController? {
        (rootViewController as? UINavigationController)
    }
}

protocol Coordinated {
    var coordinator: Coordinator? { get }
}

protocol Flow {}

extension Flow {
    var appFlow: AppFlow? {
        (self as? AppFlow)
    }
}

enum AppFlow: Flow {
    case userListFlow
}
