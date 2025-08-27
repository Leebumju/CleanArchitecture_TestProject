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
    let temp = 2
    
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
        $0.backgroundColor = .white
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
        
        bind()
    }
    
    override func addViews() {
        view.addSubviews([searchTextField,
                          gitHubUserListView])
    }
    
    override func makeConstraints() {
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 56))
        }
        
        gitHubUserListView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(moderateScale(number: 20))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-getDefaultSafeAreaBottom())
        }
    }
    
    override func setupIfNeeded() {
        searchUsers()
    }
    
    private func bind() {
        
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self = self else { return nil }
            let itemSize: NSCollectionLayoutSize
            
            if temp == 0 {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            } else {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(moderateScale(number: 100)))
            }
            
            return CompositionalLayoutProvider.configureSectionLayout(withItemLayout: .init(size: itemSize),
                                                                      groupLayout: .init(size: itemSize),
                                                                      sectionLayout: .init())
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

extension AllUserListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(GitHubUserCell.self, indexPath: indexPath) else { return .init() }
        cell.updateView(with: .init(id: 0,
                                    login: "",
                                    avatarURL: "",
                                    isFavorite: false))
        return cell
    }
}
