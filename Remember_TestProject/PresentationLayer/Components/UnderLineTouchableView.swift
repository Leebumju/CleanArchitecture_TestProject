//
//  UnderLineTouchableView.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import Then
import SnapKit

final class UnderLineTouchableView: TouchableView {
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var titleLabel = UILabel()
    
    private lazy var underlineView = UIView()
    
    init(_ title: String?) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubviews([containerView, underlineView])
        containerView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 10))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        underlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 1))
        }
    }
    
    func didSelect(_ selected: Bool) {
        titleLabel.textColor = selected ? UIColor.black : UIColor.systemGray2
        titleLabel.attributedText = selected ? FontManager.body2B.setFont(titleLabel.text, alignment: .center) : FontManager.body2M.setFont(titleLabel.text, alignment: .center)
        underlineView.backgroundColor = selected ? UIColor.black : UIColor.systemGray2
        underlineView.snp.updateConstraints {
            $0.height.equalTo(selected ? moderateScale(number: 2): moderateScale(number: 1))
        }
    }
}
