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
        
        setupViews()
        setupConstraints()
        setupIfNeeded()
    }
    
    deinit {
        deinitialize()
    }
    
    func setupViews() {}
    
    func setupConstraints() {}
    
    func setupIfNeeded() {}
    
    func deinitialize() {}
}
