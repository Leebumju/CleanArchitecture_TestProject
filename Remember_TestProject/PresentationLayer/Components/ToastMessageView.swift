//
//  ToastMessageView.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

final class ToastMessageView: UIView {
    private var bottomInset: CGFloat = 0
    
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = .gray
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    init(title: String, bottomInset: CGFloat) {
        super.init(frame: UIScreen.main.bounds)
        
        let attributedText = FontManager.body2M.setFont(title, alignment: .center)
        titleLabel.attributedText = attributedText
        
        self.isUserInteractionEnabled = true
        
        addViews()
        makeConstraints(with: bottomInset)
        self.bottomInset = bottomInset
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let maxWidth: CGFloat = UIScreen.main.bounds.width - moderateScale(number: 20 * 2)
        let currentWidth: CGFloat = backgroundView.frame.size.width
        let lineCount = Int(titleLabel.sizeThatFits(CGSize(width: titleLabel.frame.width,
                                                           height: CGFloat.greatestFiniteMagnitude)).height / titleLabel.font.lineHeight)
        
        if currentWidth > maxWidth || lineCount > 1 {
            backgroundView.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(maxWidth)
                $0.bottom.equalToSuperview().inset(getSafeAreaBottom() + bottomInset)
            }
            backgroundView.layer.cornerRadius = moderateScale(number: 24)
        } else {
            backgroundView.layer.cornerRadius = backgroundView.frame.height / 2
        }
    }
    
    private func addViews() {
        addSubviews([backgroundView])
        backgroundView.addSubviews([titleLabel])
    }
    
    private func makeConstraints(with bottomInset: CGFloat) {
        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom() + bottomInset)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 28))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 12))
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
