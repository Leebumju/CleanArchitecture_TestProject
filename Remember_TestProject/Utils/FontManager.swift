//
//  FontManager.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

enum FontSet {
    case regular
    case medium
    case bold

    func font(_ size: CGFloat) -> UIFont? {
        switch self {
        case .regular:
            return UIFont(name: "Pretendard-Regular", size: size)
        case .medium:
            return UIFont(name: "Pretendard-Medium", size: size)
        case .bold:
            return UIFont(name: "Pretendard-Bold", size: size)
        }
    }
}

enum FontManager {
    case headline2B
    case headline2M
    
    case title2B
    case title2M
    case title3B
    case title3M
    
    case body2B
    case body2M
    case body3B
    case body3M
    
    case lable2R
    case lable2M
    case lable3M
    case lable3R
    
    var font: UIFont? {
        switch self {
        case .headline2B:
            return FontSet.bold.font(moderateScale(number: 28))
        case .headline2M:
            return FontSet.medium.font(moderateScale(number: 28))
            
        case .title2B:
            return FontSet.bold.font(moderateScale(number: 20))
        case .title2M:
            return FontSet.medium.font(moderateScale(number: 20))
        case .title3B:
            return FontSet.bold.font(moderateScale(number: 18))
        case .title3M:
            return FontSet.medium.font(moderateScale(number: 18))
            
        case .body2B:
            return FontSet.bold.font(moderateScale(number: 15))
        case .body2M:
            return FontSet.medium.font(moderateScale(number: 15))
        case .body3B:
            return FontSet.bold.font(moderateScale(number: 14))
        case .body3M:
            return FontSet.medium.font(moderateScale(number: 14))
            
        case .lable2R:
            return FontSet.regular.font(moderateScale(number: 11))
        case .lable2M:
            return FontSet.medium.font(moderateScale(number: 11))
        case .lable3R:
            return FontSet.regular.font(moderateScale(number: 10))
        case .lable3M:
            return FontSet.medium.font(moderateScale(number: 10))
        }
    }
    
    private var lineHeight: CGFloat {
        switch self {
        case .headline2B, .headline2M:
            return 38
        case .title2B, .title2M:
            return 30
        case .title3B, .title3M:
            return 26
        case .body2B, .body2M:
            return 22
        case .body3B, .body3M:
            return 20
        case .lable2R, .lable2M:
            return 14
        case .lable3R, .lable3M:
            return 12
        }
    }
    
    func setFont(_ text: String? = " ", alignment: NSTextAlignment?) -> NSMutableAttributedString? {
        guard let text = text else { return nil }
        guard let font = self.font else { return nil }
        
        let fontSize: CGFloat = font.pointSize
        let lineHeight: CGFloat = max(lineHeight, fontSize + 0.2 * fontSize)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = alignment ?? .left
        
        var offsetDivisor: CGFloat = 4.0
        
        if #available(iOS 16.4, *) {
            offsetDivisor = 2.0
        }
        
        let baselineOffset: CGFloat = (lineHeight - fontSize) / offsetDivisor
        
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle,
                                                         .font: font,
                                                         .baselineOffset: baselineOffset,
                                                         .kern: -0.2]
        
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
}
