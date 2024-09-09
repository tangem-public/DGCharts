//
//  ColorSplitLineChartDataSet.swift
//  Tangem
//
//  Created by Andrey Fedorov on 01.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

public final class ColorSplitLineChartDataSet: LineChartDataSet {
    public var drawHighlightCircleEnabled = false
    public var isDrawHighlightCircleEnabled: Bool { drawHighlightCircleEnabled }

    public var outerHighlightCircleAlpha = 1.0
    public var outerHighlightCircleColor: NSUIColor = .red
    public var outerHighlightCircleRadius = 10.0

    public var innerHighlightCircleAlpha = 1.0
    public var innerHighlightCircleColor: NSUIColor = .green
    public var innerHighlightCircleRadius = 6.0

    public var highlightCircleHoleRadius = 4.0

    // MARK: NSCopying

    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ColorSplitLineChartDataSet
        copy.drawHighlightCircleEnabled = drawHighlightCircleEnabled
        copy.outerHighlightCircleAlpha = outerHighlightCircleAlpha
        copy.outerHighlightCircleColor = outerHighlightCircleColor
        copy.outerHighlightCircleRadius = outerHighlightCircleRadius
        copy.innerHighlightCircleAlpha = innerHighlightCircleAlpha
        copy.innerHighlightCircleColor = innerHighlightCircleColor
        copy.innerHighlightCircleRadius = innerHighlightCircleRadius
        copy.highlightCircleHoleRadius = highlightCircleHoleRadius

        return copy
    }
}
