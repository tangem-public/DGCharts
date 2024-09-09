//
//  ColorSplitLineChartRenderer.swift
//  Tangem
//
//  Created by Andrey Fedorov on 31.07.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import CoreGraphics

/// A chart renderer capable of rendering line charts using different appearance for parts before/after the highlighted point.
public final class ColorSplitLineChartRenderer: LineChartRenderer {
    override public func drawHighlighted(context: CGContext, indices: [Highlight]) {
        super.drawHighlighted(context: context, indices: indices)

        guard
            !indices.isEmpty,
            let dataProvider = dataProvider,
            let lineData = dataProvider.lineData
        else {
            return
        }

        let phaseY = animator.phaseY

        context.saveGState()
        defer { context.restoreGState() }

        for highlight in indices {
            guard
                let dataSet = lineData.dataSets[highlight.dataSetIndex] as? ColorSplitLineChartDataSet,
                dataSet.isVisible,
                dataSet.isDrawHighlightCircleEnabled
            else {
                continue
            }

            let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
            let valueToPixelMatrix = trans.valueToPixelMatrix

            let centerPoint = CGPoint(
                x: highlight.x,
                y: CGFloat(highlight.y * phaseY)
            ).applying(valueToPixelMatrix)

            guard
                viewPortHandler.isInBoundsLeft(centerPoint.x),
                viewPortHandler.isInBoundsRight(centerPoint.x),
                viewPortHandler.isInBoundsY(centerPoint.y)
            else {
                continue
            }

            let outerRect = CGRect(center: centerPoint, dimension: dataSet.outerHighlightCircleRadius * 2.0)
            let outerRectColor = dataSet.outerHighlightCircleColor.withAlphaComponent(dataSet.outerHighlightCircleAlpha)

            let innerRect = CGRect(center: centerPoint, dimension: dataSet.innerHighlightCircleRadius * 2.0)
            let innerRectColor = dataSet.innerHighlightCircleColor.withAlphaComponent(dataSet.innerHighlightCircleAlpha)
            let holeRect = CGRect(center: centerPoint, dimension: dataSet.highlightCircleHoleRadius * 2.0)

            context.beginPath()

            // Draw an outer circle of radius `outerHighlightCircleRadius` with
            // a transparent hole of radius `innerHighlightCircleRadius` inside it
            context.saveGState()
            context.setFillColor(outerRectColor.cgColor)
            context.addEllipse(in: outerRect)
            context.addEllipse(in: innerRect)
            context.fillPath(using: .evenOdd)
            context.restoreGState()

            // Draw an inner circle of radius `innerHighlightCircleRadius` with
            // a transparent hole of radius `highlightCircleHoleRadius` inside it
            context.setFillColor(innerRectColor.cgColor)
            context.addEllipse(in: innerRect)
            context.addEllipse(in: holeRect)
            context.fillPath(using: .evenOdd)
        }
    }
}
