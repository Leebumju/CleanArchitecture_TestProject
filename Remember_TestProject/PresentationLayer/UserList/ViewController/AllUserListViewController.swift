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
    // MARK: - Properties
    private var cancelBag = Set<AnyCancellable>()
    private let viewModel: AllUserListViewModel

    // MARK: - UI Components
    private lazy var searchTextField: UITextField = makeSearchTextField()
    private lazy var gitHubUserListView: UICollectionView = makeCollectionView()

    // MARK: - Life Cycle
    init(viewModel: AllUserListViewModel) {
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Binding
private extension AllUserListViewController {
    func bindViewModel() {
        bindUsers()
        bindLoading()
        bindErrors()
    }

    func bindUsers() {
        viewModel.searchedUsersPublisher
            .mainSink { [weak self] _ in
                self?.gitHubUserListView.reloadData()
            }.store(in: &cancelBag)
    }

    func bindLoading() {
        viewModel.isLoadingPublisher
            .mainSink { isLoading in
                guard !self.viewModel.isPaging else { return }
                isLoading ? CommonUtil.showLoadingView() : CommonUtil.hideLoadingView()
            }.store(in: &cancelBag)
    }

    func bindErrors() {
        viewModel.errorPublisher
            .mainSink { [weak self] error in
                self?.showToastMessageView(title: error.localizedDescription)
            }.store(in: &cancelBag)
    }
}

// MARK: - Actions
private extension AllUserListViewController {
    func searchUsers(keyword: String) { viewModel.searchUsers(keyword: keyword) }
    func loadNextPage() { viewModel.loadNextPage() }

    @objc func dismissKeyboard() { view.endEditing(true) }
}

// MARK: - UITextFieldDelegate
extension AllUserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let keyword = textField.text { searchUsers(keyword: keyword) }
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension AllUserListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchedUsers.isEmpty ? 1 : viewModel.searchedUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.searchedUsers.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(NoSearchedDataCell.self, indexPath: indexPath) else { return .init() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(GitHubUserCell.self, indexPath: indexPath) else { return .init() }
            let user = viewModel.searchedUsers[indexPath.item]
            cell.updateView(with: user)
            cell.favoriteButton.didTapped { [weak self] in self?.viewModel.toggleFavorite(user) }
            return cell
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension AllUserListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxIndex = indexPaths.map({ $0.item }).max(),
              maxIndex >= viewModel.searchedUsers.count - 5 else { return }
        loadNextPage()
    }
}

// MARK: - UI Factory
private extension AllUserListViewController {
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
            $0.delegate = self
        }
    }

    func makeCollectionView() -> UICollectionView {
        UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
            $0.showsVerticalScrollIndicator = false
            $0.dataSource = self
            $0.prefetchDataSource = self
            $0.registerCell(NoSearchedDataCell.self)
            $0.registerCell(GitHubUserCell.self)
            $0.backgroundColor = .white
        }
    }

    func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self = self else { return nil }
            let itemHeight: NSCollectionLayoutDimension = self.viewModel.searchedUsers.isEmpty
                ? .fractionalHeight(1)
                : .estimated(moderateScale(number: 60))
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
            return CompositionalLayoutProvider.configureSectionLayout(
                withItemLayout: .init(size: itemSize),
                groupLayout: .init(size: itemSize),
                sectionLayout: .init()
            )
        }
    }
}
