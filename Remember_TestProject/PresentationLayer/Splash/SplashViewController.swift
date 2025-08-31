//
//  ViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/26/25.
//

import UIKit
import SnapKit
import Then

final class SplashViewController: BaseViewController, AppCoordinated {
    
    var coordinator: AnyAppCoordinator?
    
    private lazy var titleLabel: UILabel = UILabel().then {
        $0.attributedText = FontManager.headline2B.setFont("Remember TestProject",
                                                           alignment: .center)
        $0.textColor = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        view.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.coordinator?.moveTo(.userListFlow, userData: nil)
        }
    }
}
