//
//  ScreenUtil.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

private let baseGuideWidth: CGFloat = 375.0
private let baseGuideHeight: CGFloat = 812.0

@inline(__always)
private func horizontalScale(number: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.width / baseGuideWidth * number
}

@inline(__always)
func moderateScale(number: CGFloat, factor: CGFloat = 0.5) -> CGFloat {
    return number + (horizontalScale(number: number) - number) * factor
}

@inline(__always)
func getSafeAreaTop() -> CGFloat {
    return UIApplication.shared.currentKeyWindow?.safeAreaInsets.top ?? 0
}

@inline(__always)
func getSafeAreaBottom() -> CGFloat {
    return UIApplication.shared.currentKeyWindow?.safeAreaInsets.bottom ?? 0
}

@inline(__always)
func getDefaultSafeAreaBottom() -> CGFloat {
    return getSafeAreaBottom() == 0 ? moderateScale(number: 34) : getSafeAreaBottom()
}
