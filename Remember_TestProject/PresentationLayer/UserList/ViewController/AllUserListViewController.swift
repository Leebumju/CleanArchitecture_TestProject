//
//  AllUserListViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class AllUserListViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    private let viewModel: AllUserListViewModel
    
    private(set) lazy var searchTextField: UITextField = UITextField().then {
        $0.addLeftPadding(moderateScale(number: 12))
        $0.addRightPadding(moderateScale(number: 12))
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.textColor = .black
        $0.setCustomPlaceholder(placeholder: "검색어를 입력하세요.",
                                color: .systemGray3,
                                font: FontManager.body2M.font)
        $0.delegate = self
    }
    
    private lazy var gitHubUserListView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.prefetchDataSource = self
        $0.registerCell(NoSearchedDataCell.self)
        $0.registerCell(GitHubUserCell.self)
        $0.backgroundColor = .white
    }
    
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
        view.addSubviews([searchTextField, gitHubUserListView])
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func bind() {
        viewModel.searchedUsersPublisher
            .droppedSink { [weak self] _ in
                self?.gitHubUserListView.reloadData()
            }.store(in: &cancelBag)
        
        viewModel.isLoadingPublisher
            .mainSink { isLoading in
                if isLoading { CommonUtil.showLoadingView() }
                else { CommonUtil.hideLoadingView() }
            }.store(in: &cancelBag)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self = self else { return nil }
            let itemSize: NSCollectionLayoutSize
            
            if self.viewModel.searchedUsers.isEmpty {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(moderateScale(number: 1)))
            } else {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(moderateScale(number: 60)))
            }
            
            return CompositionalLayoutProvider.configureSectionLayout(
                withItemLayout: .init(size: itemSize),
                groupLayout: .init(size: itemSize),
                sectionLayout: .init()
            )
        }
    }
    
    private func searchUsers(keyword: String) {
        viewModel.searchUsers(keyword: keyword)
    }
    
    private func loadNextPage() {
        viewModel.loadNextPage()
    }
    
    @objc
    private func handleTapGesture() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension AllUserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let keyword = textField.text {
            searchUsers(keyword: keyword)
        }
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension AllUserListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchedUsers.isEmpty ? 1 : viewModel.searchedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.searchedUsers.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(NoSearchedDataCell.self, indexPath: indexPath) else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(GitHubUserCell.self, indexPath: indexPath) else {
                return UICollectionViewCell()
            }
            
            let user = viewModel.searchedUsers[indexPath.item]
            cell.updateView(with: user)
            
            cell.favoriteButton.didTapped { [weak self] in
                self?.viewModel.toggleFavorite(user)
            }
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension AllUserListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxIndex = indexPaths.map({ $0.item }).max() else { return }
        if maxIndex >= viewModel.searchedUsers.count - 5 {
            loadNextPage()
        }
    }
}
