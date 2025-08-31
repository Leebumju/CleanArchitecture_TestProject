//
//  UIApplication.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/31/25.
//

import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
