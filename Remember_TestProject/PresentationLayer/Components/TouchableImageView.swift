//
//  TouchableImageView.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

final class TouchableImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
       
        let touchArea = bounds.insetBy(dx: -10, dy: -10)
        return touchArea.contains(point)
    }
    
    func didTapped(onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(tapAction(withGesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc
    private func tapAction(withGesture gesture: TapGestureRecognizer) {
        gesture.onTapped?()
    }
}
