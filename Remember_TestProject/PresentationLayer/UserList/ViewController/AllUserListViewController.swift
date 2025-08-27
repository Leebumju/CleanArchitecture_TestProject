//
//  AllUserListViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import SnapKit
import Then

final class AllUserListViewController: BaseViewController {
    
    private let viewModel: AllUserListViewModel
    
    init(viewModel: AllUserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func addViews() {
        
    }
    
    override func makeConstraints() {
        
    }
    
    override func setupIfNeeded() {
        searchUsers()
    }
    
    private func searchUsers() {
        Task {
            do {
                CommonUtil.showLoadingView()
                try await viewModel.searchUsers(with: "d")
                CommonUtil.hideLoadingView()
            } catch {}
        }
    }
}
