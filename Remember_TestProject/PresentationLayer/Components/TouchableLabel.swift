//
//  TouchableLabel.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

class TouchableLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    func didTapped(setEffect: Bool? = true, onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(tapAction(withGesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc
    private func tapAction(withGesture gesture: TapGestureRecognizer) {
        gesture.onTapped?()
    }
    
    @MainActor
    func setClickable(_ clickable: Bool) {
        if clickable {
            isUserInteractionEnabled = true
            backgroundColor = .systemBlue
            font = FontManager.body2M.font
        } else {
            isUserInteractionEnabled = false
            backgroundColor = .systemGray3
            font = FontManager.body2M.font
        }
    }
}
