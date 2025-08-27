//
//  BaseAlertViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/26/25.
//

import UIKit
import Then
import SnapKit

class BaseAlertViewController: UIViewController {

    private lazy var backgroundView = UIView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
    }
    
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
        $0.layoutMargins = UIEdgeInsets(top: moderateScale(number: 24),
                                        left: moderateScale(number: 24),
                                        bottom: moderateScale(number: 24),
                                        right: moderateScale(number: 24))
    }
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private(set) lazy var descriptionLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func bind(title: String?,
              description: String?,
              submitText: String? = nil,
              submitCompletion: (() -> Void)?) {
        confirmButton.didTapped { [weak self] in
            self?.dismiss(animated: false)
            submitCompletion?()
        }

        titleLabel.text = title
        
        if let description = description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let submitText = submitText {
            confirmButton.text = submitText
        }
    }
    
    func addViews() {
        view.addSubviews([backgroundView, containerView])
        containerView.addSubviews([titleStackView, confirmButton])
        titleStackView.addArrangedSubviews([titleLabel, descriptionLabel])
    }
    
    func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 30))
            $0.center.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom)
            $0.height.equalTo(moderateScale(number: 52))
            $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
}
