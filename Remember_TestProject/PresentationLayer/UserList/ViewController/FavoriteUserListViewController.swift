//
//  FavoriteUserListViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class FavoriteUserListViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    private(set) lazy var searchTextField: UITextField = UITextField().then {
        $0.addLeftPadding(moderateScale(number: 12))
        $0.addRightPadding(moderateScale(number: 8 + 16 + 12))
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.textColor = .black
        $0.setCustomPlaceholder(placeholder: "검색어를 입력하세요.",
                                color: .systemGray3,
                                font: FontManager.body2M.font)
        $0.delegate = self
    }
    
    private lazy var favoriteUserListView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
//        $0.prefetchDataSource = self
        $0.registerCell(NoSearchedDataCell.self)
        $0.registerCell(GitHubUserCell.self)
        $0.registerSupplimentaryView(FavoriteUserSectionHeader.self,
                                     supplementaryViewOfKind: .header)
        $0.backgroundColor = .white
    }
    
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
        
        bind()
    }
    
    override func addViews() {
        view.addSubviews([searchTextField,
                          favoriteUserListView])
    }
    
    override func makeConstraints() {
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 56))
        }
        
        favoriteUserListView.snp.makeConstraints {
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
//        viewModel.getErrorSubject()
//            .mainSink { [weak self] error in
//                self?.showToastMessageView(title: error.localizedDescription)
//            }.store(in: &cancelBag)
        
        viewModel.favoriteUsersSectionsPublisher
            .droppedSink { [weak self] _ in
                guard let self = self else { return }
                favoriteUserListView.reloadData()
            }.store(in: &cancelBag)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self = self else { return nil }
            let itemSize: NSCollectionLayoutSize
            var headerSize: NSCollectionLayoutSize? = nil
            
            if viewModel.favoriteUsers.isEmpty {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            } else {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .absolute(moderateScale(number: 60)))
                headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .absolute(moderateScale(number: 20)))
                
            }
            
            return CompositionalLayoutProvider.configureSectionLayout(withItemLayout: .init(size: itemSize),
                                                                      groupLayout: .init(size: itemSize),
                                                                      sectionLayout: .init(headerSize: headerSize))
        }
    }
    
    private func toggleFavorite(_ user: GitHubUserEntity) {
        do {
            CommonUtil.showLoadingView()
            try viewModel.toggleFavorite(user)
            CommonUtil.hideLoadingView()
        } catch {}
    }
    
    @objc
    private func handleTapGesture() {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate
extension FavoriteUserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}


extension FavoriteUserListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.favoriteUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueSupplimentaryView(FavoriteUserSectionHeader.self,
                                                                           supplementaryViewOfKind: .header,
                                                                           indexPath: indexPath) else {
                return .init()
            }
            
            let section = viewModel.favoriteUsers[indexPath.section]
            headerView.updateView(with: section.title)
            return headerView
        }
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let favoriteUsers = viewModel.favoriteUsers
        
        if favoriteUsers.isEmpty {
            return 1
        } else {
            return favoriteUsers[section].users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favoriteUsers = viewModel.favoriteUsers
        let section = favoriteUsers[indexPath.section]
        let user = section.users[indexPath.item]
        
        if favoriteUsers.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(NoSearchedDataCell.self, indexPath: indexPath) else { return .init() }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(GitHubUserCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(with: user)
            cell.favoriteButton.didTapped { [weak self] in
                self?.toggleFavorite(user)
            }
            
            return cell
        }
    }
}
