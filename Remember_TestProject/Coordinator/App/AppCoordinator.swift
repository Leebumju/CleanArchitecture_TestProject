//
//  AppCoordinator.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

final class AppCoordinator: AppCoordinatable {
    var parentCoordinator: AnyCoordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let splashVC: SplashViewController = SplashViewController()
        splashVC.coordinator = self
        
        rootViewController = UINavigationController(rootViewController: splashVC)
        rootViewController.hidesBottomBarWhenPushed = true
        
        let navigation: UINavigationController? = rootViewController as? UINavigationController
        navigation?.isNavigationBarHidden = true
        return rootViewController
    }
    
    func moveTo(_ appFlow: AppFlow, userData: [String: Any]?) {
        guard let flow = appFlow.appFlow else { return }
      
        switch flow {
        case .userListFlow:
            startUserListFlow(userData: userData)
        }
    }
    
    private func startUserListFlow(userData: [String: Any]?) {
        let allUseCase = Injector.shared.resolve(AllUserListUsecaseProtocol.self)!
        let favoriteUseCase = Injector.shared.resolve(FavoriteUserListUsecaseProtocol.self)!
        
        let allVM = AllUserListViewModel(usecase: allUseCase)
        let favoriteVM = FavoriteUserListViewModel(usecase: favoriteUseCase)
        
        let allVC = AllUserListViewController(viewModel: allVM)
        let favoriteVC = FavoriteUserListViewController(viewModel: favoriteVM)
        
        let userListVC = UserListViewController(allUserListVC: allVC,
                                                favoriteUserListVC: favoriteVC)
        userListVC.coordinator = self
        
        rootNavigationController?.pushViewController(userListVC, animated: true)
    }
}
