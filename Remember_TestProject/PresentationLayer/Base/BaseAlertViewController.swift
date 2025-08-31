//
//  BaseAlertViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/26/25.
//

import UIKit
import Then
import SnapKit

final class BaseAlertViewController: UIViewController {

    // MARK: - Properties
    private lazy var backgroundView = UIView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }

    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
    }

    // MARK: - UI Components
    private lazy var confirmButton = TouchableLabel().then {
        $0.text = "확인"
        $0.textColor = .white
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.backgroundColor = .blue
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
    }

    private(set) lazy var titleStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 12)
        $0.axis = .vertical
        $0.backgroundColor = .white
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(
            top: moderateScale(number: 24),
            left: moderateScale(number: 24),
            bottom: moderateScale(number: 24),
            right: moderateScale(number: 24)
        )
    }

    private(set) lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private(set) lazy var descriptionLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    // MARK: - Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup
    private func setupViews() {
        view.addSubviews([backgroundView, containerView])
        containerView.addSubviews([titleStackView, confirmButton])
        titleStackView.addArrangedSubviews([titleLabel, descriptionLabel])
    }

    private func setupConstraints() {
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 30))
            $0.center.equalToSuperview()
        }

        titleStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom)
            $0.height.equalTo(moderateScale(number: 52))
            $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 24))
        }
    }
    
    // MARK: - Binding
    func bind(title: String?,
              description: String?,
              submitText: String? = nil,
              submitCompletion: (() -> Void)? = nil) {
        confirmButton.didTapped { [weak self] in
            self?.dismiss(animated: false)
            submitCompletion?()
        }
        
        titleLabel.text = title
        descriptionLabel.isHidden = description == nil
        descriptionLabel.text = description
        if let submitText = submitText { confirmButton.text = submitText }
    }
}
