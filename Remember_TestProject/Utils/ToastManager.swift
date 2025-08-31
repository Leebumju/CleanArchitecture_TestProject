//
//  ToastManager.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/31/25.
//

import UIKit

final class ToastManager {
    static func show(title: String, duration: TimeInterval = 2, bottomInset: CGFloat = 40) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let toastView = ToastMessageView(title: title, bottomInset: bottomInset)
        window.addSubview(toastView)
        window.bringSubviewToFront(toastView)
        toastView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: { toastView.alpha = 1 }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: [], animations: { toastView.alpha = 0 }) { _ in
                toastView.removeFromSuperview()
            }
        }
    }
}
