//
//  UIView+Extension.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

extension UIView {
    func addSubviews<T: UIView>(_ subviews: [T], completionHandler closure: (([T]) -> Void)? = nil) {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
    }
}
