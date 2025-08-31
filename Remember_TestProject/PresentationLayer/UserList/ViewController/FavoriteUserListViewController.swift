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

import UIKit
import SnapKit
import Then
import Combine

final class FavoriteUserListViewController: BaseViewController {
    // MARK: - Properties
    private var cancelBag = Set<AnyCancellable>()
    private let viewModel: FavoriteUserListViewModel

    // MARK: - UI Components
    private lazy var searchTextField: UITextField = makeSearchTextField()
    private lazy var favoriteUserListView: UICollectionView = makeCollectionView()

    // MARK: - Life Cycle
    init(viewModel: FavoriteUserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    // MARK: - Setup
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Binding
private extension FavoriteUserListViewController {
    func bindViewModel() {
        bindErrors()
        bindFavoriteUsers()
    }

    func bindErrors() {
        viewModel.errorPublisher
            .mainSink { [weak self] error in
                self?.showToastMessageView(title: error.localizedDescription)
            }.store(in: &cancelBag)
    }

    func bindFavoriteUsers() {
        viewModel.favoriteUsersSectionsPublisher
            .droppedSink { [weak self] _ in
                self?.favoriteUserListView.reloadData()
            }.store(in: &cancelBag)
    }
}

// MARK: - Actions
private extension FavoriteUserListViewController {
    func searchUsers(keyword: String) { viewModel.searchUsers(keyword: keyword) }

    @objc func dismissKeyboard() { view.endEditing(true) }

    @objc func textDidChange(_ sender: UITextField) {
        searchUsers(keyword: sender.text ?? "")
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteUserListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.favoriteUsers.isEmpty ? 1 : viewModel.favoriteUsers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueSupplimentaryView(
                FavoriteUserSectionHeader.self,
                supplementaryViewOfKind: .header,
                indexPath: indexPath
            ) else { return .init() }

            let section = viewModel.favoriteUsers[indexPath.section]
            headerView.updateView(with: section.title)
            return headerView
        }
        return .init()
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let favoriteUsers = viewModel.favoriteUsers
        return favoriteUsers.isEmpty ? 1 : favoriteUsers[section].users.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favoriteUsers = viewModel.favoriteUsers

        if favoriteUsers.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(NoSearchedDataCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(titleText: "등록된 즐겨찾기 유저가 없어요!")
            return cell
        } else {
            let section = favoriteUsers[indexPath.section]
            let user = section.users[indexPath.item]

            guard let cell = collectionView.dequeueReusableCell(GitHubUserCell.self, indexPath: indexPath) else { return .init() }
            cell.updateView(with: user)
            cell.favoriteButton.didTapped { [weak self] in
                self?.viewModel.toggleFavorite(user)
            }

            return cell
        }
    }
}

// MARK: - UI Factory
private extension FavoriteUserListViewController {
    func makeSearchTextField() -> UITextField {
        UITextField().then {
            $0.addLeftPadding(moderateScale(number: 12))
            $0.addRightPadding(moderateScale(number: 8 + 16 + 12))
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = moderateScale(number: 12)
            $0.textColor = .black
            $0.setCustomPlaceholder(placeholder: "검색어를 입력하세요.",
                                    color: .systemGray3,
                                    font: FontManager.body2M.font)
            $0.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        }
    }

    func makeCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
            $0.showsVerticalScrollIndicator = false
            $0.dataSource = self
            $0.registerCell(NoSearchedDataCell.self)
            $0.registerCell(GitHubUserCell.self)
            $0.registerSupplimentaryView(FavoriteUserSectionHeader.self, supplementaryViewOfKind: .header)
            $0.backgroundColor = .white
        }
    }

    func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
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

            return CompositionalLayoutProvider.configureSectionLayout(
                withItemLayout: .init(size: itemSize),
                groupLayout: .init(size: itemSize),
                sectionLayout: .init(headerSize: headerSize)
            )
        }
    }
}
