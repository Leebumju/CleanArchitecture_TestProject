//
//  Coordinatable.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/26/25.
//

import UIKit

typealias AnyCoordinator = (any Coordinatable)

protocol Coordinatable: AnyObject {
    associatedtype FlowType: Flow
    
    var parentCoordinator: AnyCoordinator? { get set }
    var rootViewController: UIViewController { get set }
    
    func start() -> UIViewController
    func moveTo(_ appFlow: FlowType, userData: [String: Any]?)
}

extension Coordinatable {
    var rootNavigationController: UINavigationController? {
        return (rootViewController as? UINavigationController)
    }
    
    func moveToAnotherFlow<T: Flow>(_ flow: T, userData: [String: Any]?) {
        guard let flow = flow as? FlowType else {
            parentCoordinator?.moveToAnotherFlow(flow, userData: userData)
            return
        }
        
        moveTo(flow, userData: userData)
    }
}

final class CurrentFlowManager {
    var currentCoordinator: AnyCoordinator?
}

protocol CurrentCoordinated: AnyObject {
    var currentFlowManager: CurrentFlowManager? { get set }
}

extension CurrentCoordinated {
    var currentNavigationViewController: UINavigationController? {
        return currentFlowManager?.currentCoordinator?.rootViewController as? UINavigationController
    }
}
