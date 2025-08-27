//
//  CommonUtil.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

final class CommonUtil {
    static let shared = CommonUtil()
    
    private init() {}
    
    static func showAlertView(title: String?,
                              description: String?,
                              submitText: String? = nil,
                              submitCompletion: (() -> Void)?) {
        guard let topVC = topViewController() else { return }
        guard !(topVC is BaseAlertViewController) else { return }
        
        hideLoadingView()
        
        let alertVC: BaseAlertViewController = BaseAlertViewController()
        alertVC.bind(title: title,
                     description: description,
                     submitText: submitText,
                     submitCompletion: submitCompletion)
        alertVC.modalPresentationStyle = .overFullScreen
        topVC.present(alertVC, animated: false)
    }
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.last { $0.isKeyWindow }
        var topVC = keyWindow?.rootViewController
        
        while true {
            if let presented = topVC?.presentedViewController {
                topVC = presented
            } else if let navigationController = topVC as? UINavigationController {
                topVC = navigationController.visibleViewController
            } else if let tabBarController = topVC as? UITabBarController {
                topVC = tabBarController.selectedViewController
            } else {
                break
            }
        }
        
        return topVC
    }
    
    static func showLoadingView() {
        guard UIApplication.shared.windows.last?.subviews.contains(where: { $0 is LoadingView }) == false else { return }
        
        let loadingView = LoadingView()
        loadingView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        UIApplication.shared.windows.last?.addSubview(loadingView)
    }
    
    static func hideLoadingView() {
        if let loadingView = UIApplication.shared.windows.last?.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        } else if let loadingView = UIApplication.shared.windows.first?.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        } else if let topVC = CommonUtil.topViewController(), let loadingView = topVC.view.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        }
    }
}
