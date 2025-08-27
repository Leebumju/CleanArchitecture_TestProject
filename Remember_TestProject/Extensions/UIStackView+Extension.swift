//
//  UIStackView+Extension.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
