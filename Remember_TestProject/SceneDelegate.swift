//
//  SceneDelegate.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/26/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var coordinator: AnyAppCoordinator?
    var window: UIWindow?
    private var currentScene: UIScene?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        currentScene = scene
        coordinator = AppCoordinator()
        setRootViewController(coordinator!.start())
        window?.overrideUserInterfaceStyle = .light
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    private func setRootViewController(_ viewController: UIViewController) {
        guard let scene = (currentScene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
