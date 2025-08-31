//
//  LoadingManager.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/31/25.
//

import UIKit

final class LoadingManager {
    static let shared = LoadingManager()
    private init() {}
    
    private var loadingView: LoadingView?
    
    func show() {
        guard loadingView == nil, let keyWindow = UIApplication.shared.currentKeyWindow else { return }
        let view = LoadingView()
        view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        keyWindow.addSubview(view)
        self.loadingView = view
    }
    
    func hide() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
