//
//  FavoriteUserSectionHeader.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/28/25.
//

import UIKit
import Then
import SnapKit

final class FavoriteUserSectionHeader: UICollectionReusableView {
    private lazy var titleLabel = UILabel().then {
        $0.attributedText = FontManager.body3M.setFont(alignment: .left)
        $0.textColor = .systemGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
        }
    }
    
    func updateView(with titleText: String) {
        titleLabel.text = titleText
    }
}
