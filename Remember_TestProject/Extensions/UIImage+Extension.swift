//
//  UIImage+Extension.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/28/25.
//

import UIKit

extension UIImage {
    func tinted(_ color: UIColor) -> UIImage {
        return self.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
