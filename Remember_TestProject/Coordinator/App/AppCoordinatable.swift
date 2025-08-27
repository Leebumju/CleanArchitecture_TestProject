//
//  AppCoordinatable.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/26/25.
//

typealias AnyAppCoordinator = (any AppCoordinatable)

protocol AppCoordinatable: Coordinatable where FlowType == AppFlow {
}

protocol AppCoordinated {
    var coordinator: AnyAppCoordinator? { get }
}
