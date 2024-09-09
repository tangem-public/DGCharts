//
//  ColorSplitLineChartSegmentAppearance.swift
//  Tangem
//
//  Created by Andrey Fedorov on 22.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import QuartzCore

public struct ColorSplitLineChartSegmentAppearance {
    public struct Gradient {
        public init(
            colors: [NSUIColor],
            locations: [CGFloat]? = nil,
            startPoint: CGPoint? = nil,
            endPoint: CGPoint? = nil,
            type: CAGradientLayerType? = nil
        ) {
            self.colors = colors
            self.locations = locations
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.type = type
        }

        public let colors: [NSUIColor]
        public let locations: [CGFloat]?
        public let startPoint: CGPoint?
        public let endPoint: CGPoint?
        public let type: CAGradientLayerType?
    }

    /// The color that is used for filling the line surface area.
    public let lineColor: NSUIColor

    /// The colors that are used for filling the area below the line.
    public let gradient: Gradient

    public init(
        lineColor: NSUIColor,
        gradient: Gradient
    ) {
        self.lineColor = lineColor
        self.gradient = gradient
    }
}
