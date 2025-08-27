//
//  DispatchMain.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation

final class DispatchMain {
    static func async(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
