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
    private(set) lazy var searchTextField: UITextField = UITextField().then {
        $0.addLeftPadding(moderateScale(number: 12))
        $0.addRightPadding(moderateScale(number: 8 + 16 + 12))
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.textColor = .black
        $0.setCustomPlaceholder(placeholder: "검색어를 입력하세요.",
                                color: .systemGray3,
                                font: FontManager.body2M.font)
    }
    
    private lazy var gitHubUserListView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.registerCell(NoSearchedDataCell.self)
        $0.registerCell(GitHubUserCell.self)
        $0.backgroundColor = .systemGray6
    }
    
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
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self = self else { return nil }
            let itemSize: NSCollectionLayoutSize
            
        }
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
