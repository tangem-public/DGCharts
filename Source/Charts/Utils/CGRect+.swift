//
//  CGRect+.swift
//  Tangem
//
//  Created by Andrey Fedorov on 01.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    init(center: CGPoint, dimension: CGFloat) {
        self.init(
            x: center.x - dimension / 2.0,
            y: center.y - dimension / 2.0,
            width: dimension,
            height: dimension
        )
    }
}
