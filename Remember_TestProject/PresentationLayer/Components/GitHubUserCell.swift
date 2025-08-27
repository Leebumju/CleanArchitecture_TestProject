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
        $0.layer.cornerRadius = moderateScale(number: 12)
    }
    
    private lazy var avatarImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
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
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([avatarImageView,
                                   userLoginLabel,
                                   favoriteButton])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 12))
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
    }
    
    func updateView(with gitHubUser: GitHubUserEntity) {
    
    }
}
