//
//  GitHubUserCell.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import Then
import SnapKit

final class GitHubUserCell: UICollectionViewCell {
    private(set) lazy var containerView: TouchableView = TouchableView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var avatarImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.circle.fill")?.tinted(.systemGray5)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var userLoginLabel: UILabel = UILabel().then {
        $0.attributedText = FontManager.body2B.setFont(alignment: .left)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }

    private(set) lazy var favoriteButton: TouchableImageView = TouchableImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var dividerView: UIView = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubviews([avatarImageView,
                                   userLoginLabel,
                                   favoriteButton,
                                   dividerView])
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(moderateScale(number: 12))
            $0.size.equalTo(moderateScale(number: 36))
        }
        
        userLoginLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(favoriteButton.snp.leading).offset(moderateScale(number: -4))
        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -12))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        dividerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 1))
        }
    }
    
    func updateView(with gitHubUser: GitHubUserEntity) {
        userLoginLabel.text = gitHubUser.login
        favoriteButton.image = UIImage(systemName: "star.fill")?.tinted(
            gitHubUser.isFavorite ? .systemYellow : .systemGray5
        )
        
        if gitHubUser.avatarUrl.isEmpty {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")?.tinted(.systemGray5)
        } else {
            avatarImageView.setImageWithSpinner(
                urlString: gitHubUser.avatarUrl,
                placeholder: UIImage(systemName: "person.circle.fill")?.tinted(.systemGray5)
            )
        }
    }
}
