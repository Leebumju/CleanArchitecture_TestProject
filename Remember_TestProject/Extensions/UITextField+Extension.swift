//
//  UITextFieldView+Extension.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding: CGFloat) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: padding,
                                                       height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addRightPadding(_ padding: CGFloat) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: padding,
                                                       height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setCustomPlaceholder(placeholder: String?, color: UIColor?, font: UIFont?) {
        guard let placeholder = placeholder else { return }
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let color = color { attributes[.foregroundColor] = color }
        if let font = font { attributes[.font] = font }
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: attributes)
    }
}
