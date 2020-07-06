//
//  SwiftExtension.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/24/20.
//  Copyright © 2020 boo. All rights reserved.
//

import Foundation

func mainQueueExecuting(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}

extension Sequence {
    /// Numbers the elements in `self`, starting with the specified number.
    /// - Returns: An array of (Int, Element) pairs.
    func numbered(startingAt start: Int = 1) -> [(number: Int, element: Element)] {
        Array(zip(start..., self))
    }
}
