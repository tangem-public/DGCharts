//
//  LineScatterCandleRadarRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@objc(LineScatterCandleRadarChartRenderer)
open class LineScatterCandleRadarRenderer: BarLineScatterCandleBubbleRenderer
{
    public override init(animator: Animator, viewPortHandler: ViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
    }
    
    /// Draws vertical & horizontal highlight-lines if enabled.
    /// :param: context
    /// :param: points
    /// :param: horizontal
    /// :param: vertical
    @objc open func drawHighlightLines(context: CGContext, point: CGPoint, set: LineScatterCandleRadarChartDataSetProtocol)
    {
        
        // draw vertical highlight lines
        if set.isVerticalHighlightIndicatorEnabled
        {
            let yStart = (viewPortHandler.contentTop + set.verticalHighlightIndicatorInset)
                .clamped(to: .zero ... .greatestFiniteMagnitude)

            let yEnd = (viewPortHandler.contentBottom - set.verticalHighlightIndicatorInset)
                .clamped(to: .zero ... .greatestFiniteMagnitude)

            context.beginPath()
            context.move(to: CGPoint(x: point.x, y: yStart))
            context.addLine(to: CGPoint(x: point.x, y: yEnd))
            context.strokePath()
        }
        
        // draw horizontal highlight lines
        if set.isHorizontalHighlightIndicatorEnabled
        {
            let xStart = (viewPortHandler.contentLeft + set.verticalHighlightIndicatorInset)
                .clamped(to: .zero ... .greatestFiniteMagnitude)

            let xEnd = (viewPortHandler.contentRight - set.verticalHighlightIndicatorInset)
                .clamped(to: .zero ... .greatestFiniteMagnitude)

            context.beginPath()
            context.move(to: CGPoint(x: xStart, y: point.y))
            context.addLine(to: CGPoint(x: xEnd, y: point.y))
            context.strokePath()
        }
    }
}
