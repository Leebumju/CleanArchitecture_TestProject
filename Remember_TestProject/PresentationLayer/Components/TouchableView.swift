//
//  TouchableView.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

final class TapGestureRecognizer: UITapGestureRecognizer {
    var onTapped: (() -> Void)?
}

class TouchableView: UIView {
    fileprivate var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    convenience init(_ vibrate: Bool = false) {
        self.init()
        self.impactFeedbackGenerator = vibrate ? UIImpactFeedbackGenerator(style: .light) : nil
    }
    
    private var effectColor: UIColor?
    
    convenience init(effectColor: UIColor?) {
        self.init()
        self.effectColor = effectColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        
        /// x: 10, y: 15 만큼 영역 증가
        /// dx: x축이 dx만큼 증가 (음수여야 증가)
        let touchArea = bounds.insetBy(dx: -10, dy: -15)
        return touchArea.contains(point)
    }
    
    func didTapped(onTapped: @escaping () -> Void) {
        let gesture = TapGestureRecognizer(target: self, action: #selector(tapAction(withGesture:)))
        gesture.onTapped = onTapped
        addGestureRecognizer(gesture)
    }
    
    @objc
    private func tapAction(withGesture gesture: TapGestureRecognizer) {
        impactFeedbackGenerator?.impactOccurred()
        gesture.onTapped?()
    }
}
