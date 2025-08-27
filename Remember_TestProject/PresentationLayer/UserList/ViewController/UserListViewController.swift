//
//  UserListViewController.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit
import Combine
import Then
import SnapKit

final class UserListViewController: BaseViewController, AppCoordinated {
    var coordinator: AnyAppCoordinator?
    
    private lazy var titleLabel = UILabel().then {
        $0.attributedText = FontManager.headline2B.setFont("GitHub Stars",
                                                           alignment: .left)
        $0.textColor = .black
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addViews() {
        super.addViews()
        view.addSubviews([titleLabel])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 20) + getSafeAreaTop())
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
    }
}
