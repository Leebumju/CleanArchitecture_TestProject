//
//  NoSearchedDataCell.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import SnapKit
import Then

final class NoSearchedDataCell: UICollectionViewCell {
    private lazy var noDataLabel: UILabel = UILabel().then {
        $0.attributedText = FontManager.body2M.setFont("검색 결과가 없어요!\n검색어를 입력해 주세요.",
                                                       alignment: .center)
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(noDataLabel)
        
        noDataLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(moderateScale(number: -30))
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
