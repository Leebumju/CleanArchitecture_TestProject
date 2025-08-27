//
//  BaseViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    deinit {
        deinitialize()
    }
    
    func addViews() {}
    
    func makeConstraints() {}
    
    func setupIfNeeded() {}
    
    func deinitialize() {}
    
    func showToastMessageView(title: String?, duration: TimeInterval = 2, bottomInset: CGFloat = moderateScale(number: 40), completion: (() -> Void)? = nil) {
        guard let title = title else { return }
        
        let toastView = ToastMessageView(title: title,
                                         bottomInset: bottomInset)
        view.addSubview(toastView)
        view.bringSubviewToFront(toastView)
        toastView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
            toastView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut) {
                toastView.alpha = 0
            } completion: { _ in
                toastView.removeFromSuperview()
                completion?()
            }
        }
    }
}
