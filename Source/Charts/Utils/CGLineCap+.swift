//
//  CGLineCap+.swift
//  Tangem
//
//  Created by Andrey Fedorov on 22.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import QuartzCore

extension CGLineCap {
    func toCAShapeLayerLineCap() -> CAShapeLayerLineCap {
        switch self {
        case .butt:
            return .butt
        case .round:
            return .round
        case .square:
            return .square
        @unknown default:
            assertionFailure("Unknown line cap received \(rawValue)")
            return .square
        }
    }
}
