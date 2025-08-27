//
//  FavoriteUserListViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import SnapKit
import Then

final class FavoriteUserListViewController: BaseViewController {
    
    private let viewModel: FavoriteUserListViewModel
    
    init(viewModel: FavoriteUserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
    
    override func addViews() {
        
    }
    
    override func makeConstraints() {
        
    }
    
    override func setupIfNeeded() {
        
    }
}
