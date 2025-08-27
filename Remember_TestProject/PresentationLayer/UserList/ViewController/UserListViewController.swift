//
//  UserListViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import Combine
import Then
import SnapKit

final class UserListViewController: BaseViewController, AppCoordinated {
    var coordinator: AnyAppCoordinator?
    
    private lazy var titleLabel = UILabel().then {
        $0.attributedText = FontManager.headline2B.setFont("GitHub Stars",
                                                           alignment: .left)
        $0.textColor = .black
    }
    
    private lazy var userListTabs = LineTabs(tabList: [.init(title: "API",
                                                              tabAction: { [weak self] in self?.goToAllUserList() }),
                                                        .init(title: "로컬",
                                                              tabAction: { [weak self] in self?.goToFavoriteUserList() })])
    
    private lazy var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                                     navigationOrientation: .horizontal,
                                                                                     options: nil)
    
    private let allUserListVC: AllUserListViewController
    
    private let favoriteUserListVC: FavoriteUserListViewController
    
    private lazy var userListViewControllers: [UIViewController] = {
        return [allUserListVC, favoriteUserListVC]
    }()
    
    init(allUserListVC: AllUserListViewController,
         favoriteUserListVC: FavoriteUserListViewController) {
        self.allUserListVC = allUserListVC
        self.favoriteUserListVC = favoriteUserListVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addViews() {
        view.addSubviews([titleLabel,
                          userListTabs])
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 20) + getSafeAreaTop())
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        userListTabs.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 40))
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(userListTabs.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
    }
    
    override func setupIfNeeded() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = userListViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            userListTabs.selectTab(0)
        }
    }
    
    private func goToAllUserList() {
        pageViewController.setViewControllers([allUserListVC], direction: .reverse, animated: true)
        userListTabs.selectTab(0)
    }
    
    private func goToFavoriteUserList() {
        pageViewController.setViewControllers([favoriteUserListVC], direction: .forward, animated: true)
        userListTabs.selectTab(1)
    }
}

extension UserListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = userListViewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex: Int = index - 1
        return previousIndex < 0 ? nil : userListViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = userListViewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex: Int = index + 1
        return nextIndex == userListViewControllers.count ? nil : userListViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        
        if currentVC === allUserListVC {
            userListTabs.selectTab(0)
        } else if currentVC === favoriteUserListVC {
            userListTabs.selectTab(1)
        }
    }
}
