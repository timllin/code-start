//
//  ProgressView+Extension.swift
//  code-start
//
//  Created by Тимур Калимуллин on 03.01.2025.
//

import UIKit

class TappableProgressView: UIProgressView {
    var tapAreaInsets: UIEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // Expand the hit area by the specified insets
        let largerFrame = bounds.inset(by: tapAreaInsets)
        return largerFrame.contains(point)
    }
}
