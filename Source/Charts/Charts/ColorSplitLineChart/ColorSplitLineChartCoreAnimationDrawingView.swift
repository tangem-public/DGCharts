//
//  ColorSplitLineChartCoreAnimationDrawingView.swift
//  Tangem
//
//  Created by Andrey Fedorov on 22.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import UIKit

final class ColorSplitLineChartCoreAnimationDrawingView: UIView {
    private typealias SplineDrawingView = CustomCALayerView<CAShapeLayer>
    private typealias GradientDrawingView = CustomCALayerView<CAGradientLayer>

    /// `CGPath.union(_:using:)` is available on iOS 16.0 and above, so we can't just combine two paths (rectangle-based
    /// and spline-based) and use that single combined path as a mask for `leadingGradientDrawingView.layer`
    /// and `leadingSplineDrawingView.layer`.
    /// Therefore, a rectangle-based mask is applied to the layer of this intermediate hosting view, which in turn applies
    /// this mask to all its sublayers (`leadingGradientDrawingView.layer` and `leadingSplineDrawingView.layer`).
    private lazy var leadingHostingView = UIView()

    private lazy var leadingGradientDrawingView = Self.makeGradientDrawingView()
    private lazy var leadingSplineDrawingView = Self.makeSplineDrawingView()

    private lazy var leadingGradientMask = Self.makeMaskLayer()
    private lazy var leadingHostingViewMask = Self.makeMaskLayer()

    /// `CGPath.union(_:using:)` is available on iOS 16.0 and above, so we can't just combine two paths (rectangle-based
    /// and spline-based) and use that single combined path as a mask for `trailingGradientDrawingView.layer`
    /// and `trailingSplineDrawingView.layer`.
    /// Therefore, a rectangle-based mask is applied to the layer of this intermediate hosting view, which in turn applies
    /// this mask to all its sublayers (`trailingGradientDrawingView.layer` and `trailingSplineDrawingView.layer`).
    private lazy var trailingHostingView = UIView()

    private lazy var trailingGradientDrawingView = Self.makeGradientDrawingView()
    private lazy var trailingSplineDrawingView = Self.makeSplineDrawingView()

    private lazy var trailingGradientMask = Self.makeMaskLayer()
    private lazy var trailingHostingViewMask = Self.makeMaskLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDrawingPath(
        _ path: CGPath,
        settings: LineChartDrawingPathSettings,
        leadingSegmentAppearance: ColorSplitLineChartSegmentAppearance?,
        trailingSegmentAppearance: ColorSplitLineChartSegmentAppearance?,
        lastHighlightedPoint: CGPoint?
    ) {
        if let lastHighlightedPoint {
            drawPath(
                path,
                settings: settings,
                leadingSegmentAppearance: leadingSegmentAppearance,
                trailingSegmentAppearance: trailingSegmentAppearance,
                lastHighlightedPointXCoordinate: lastHighlightedPoint.x
            )
        } else {
            drawPath(
                path,
                settings: settings,
                leadingSegmentAppearance: leadingSegmentAppearance,
                trailingSegmentAppearance: trailingSegmentAppearance
            )
        }
    }

    /// Draws a path when there is a highlighted point on the path.
    private func drawPath(
        _ path: CGPath,
        settings: LineChartDrawingPathSettings,
        leadingSegmentAppearance: ColorSplitLineChartSegmentAppearance?,
        trailingSegmentAppearance: ColorSplitLineChartSegmentAppearance?,
        lastHighlightedPointXCoordinate: CGFloat
    ) {
        let drawingRect = settings.drawingRect

        // MARK: - Configuring `leadingGradientMask`

        leadingGradientMask.frame = drawingRect
        leadingGradientMask.lineWidth = settings.lineWidth
        leadingGradientMask.lineCap = settings.lineCapType.toCAShapeLayerLineCap()
        leadingGradientMask.path = makeGradientMaskPath(from: path, bounds: leadingGradientMask.bounds)

        // MARK: - Configuring `leadingGradientDrawingView`

        leadingGradientDrawingView.layer.mask = leadingGradientMask
        leadingGradientDrawingView.customLayer.colors = leadingSegmentAppearance?.gradient.colors.map(\.cgColor)
        leadingGradientDrawingView.customLayer.locations = leadingSegmentAppearance?.gradient.locations as [NSNumber]?
        leadingSegmentAppearance?.gradient.startPoint.map { leadingGradientDrawingView.customLayer.startPoint = $0 }
        leadingSegmentAppearance?.gradient.endPoint.map { leadingGradientDrawingView.customLayer.endPoint = $0 }
        leadingSegmentAppearance?.gradient.type.map { leadingGradientDrawingView.customLayer.type = $0 }

        // MARK: - Configuring `leadingSplineDrawingView`

        leadingSplineDrawingView.customLayer.lineWidth = settings.lineWidth
        leadingSplineDrawingView.customLayer.lineCap = settings.lineCapType.toCAShapeLayerLineCap()
        leadingSplineDrawingView.customLayer.path = path
        leadingSplineDrawingView.customLayer.strokeColor = leadingSegmentAppearance?.lineColor.cgColor

        // MARK: - Configuring `leadingHostingView` and `leadingHostingViewMask`

        leadingHostingViewMask.frame = drawingRect
        leadingHostingViewMask.path = CGPath(
            rect: CGRect(
                x: .zero,
                y: .zero,
                width: lastHighlightedPointXCoordinate,
                height: drawingRect.height
            ),
            transform: nil
        )
        leadingHostingView.layer.mask = leadingHostingViewMask

        // MARK: - Configuring `trailingGradientMask`

        trailingGradientMask.frame = drawingRect
        trailingGradientMask.lineWidth = settings.lineWidth
        trailingGradientMask.lineCap = settings.lineCapType.toCAShapeLayerLineCap()
        trailingGradientMask.path = makeGradientMaskPath(from: path, bounds: trailingGradientMask.bounds)

        // MARK: - Configuring `trailingGradientDrawingView`

        trailingGradientDrawingView.layer.mask = trailingGradientMask
        trailingGradientDrawingView.customLayer.colors = trailingSegmentAppearance?.gradient.colors.map(\.cgColor)
        trailingGradientDrawingView.customLayer.locations = trailingSegmentAppearance?.gradient.locations as [NSNumber]?
        trailingSegmentAppearance?.gradient.startPoint.map { trailingGradientDrawingView.customLayer.startPoint = $0 }
        trailingSegmentAppearance?.gradient.endPoint.map { trailingGradientDrawingView.customLayer.endPoint = $0 }
        trailingSegmentAppearance?.gradient.type.map { trailingGradientDrawingView.customLayer.type = $0 }

        // MARK: - Configuring `trailingSplineDrawingView`

        trailingSplineDrawingView.customLayer.lineWidth = settings.lineWidth
        trailingSplineDrawingView.customLayer.lineCap = settings.lineCapType.toCAShapeLayerLineCap()
        trailingSplineDrawingView.customLayer.path = path
        trailingSplineDrawingView.customLayer.strokeColor = trailingSegmentAppearance?.lineColor.cgColor

        // MARK: - Configuring `trailingHostingView` and `trailingHostingViewMask`

        trailingHostingViewMask.frame = drawingRect
        trailingHostingViewMask.path = CGPath(
            rect: CGRect(
                x: lastHighlightedPointXCoordinate,
                y: .zero,
                width: drawingRect.width - lastHighlightedPointXCoordinate,
                height: drawingRect.height
            ),
            transform: nil
        )
        trailingHostingView.layer.mask = trailingHostingViewMask
    }

    /// Draws a path when there is no highlighted point on the path.
    private func drawPath(
        _ path: CGPath,
        settings: LineChartDrawingPathSettings,
        leadingSegmentAppearance: ColorSplitLineChartSegmentAppearance?,
        trailingSegmentAppearance: ColorSplitLineChartSegmentAppearance?
    ) {
        let drawingRect = settings.drawingRect

        // MARK: - Configuring `leadingGradientMask`

        leadingGradientMask.frame = drawingRect
        leadingGradientMask.lineWidth = settings.lineWidth
        leadingGradientMask.lineCap = settings.lineCapType.toCAShapeLayerLineCap()
        leadingGradientMask.path = makeGradientMaskPath(from: path, bounds: leadingGradientMask.bounds)

        // MARK: - Configuring `leadingGradientDrawingView`

        leadingGradientDrawingView.layer.mask = leadingGradientMask
        leadingGradientDrawingView.customLayer.colors = leadingSegmentAppearance?.gradient.colors.map(\.cgColor)
        leadingGradientDrawingView.customLayer.locations = leadingSegmentAppearance?.gradient.locations as [NSNumber]?
        leadingSegmentAppearance?.gradient.startPoint.map { leadingGradientDrawingView.customLayer.startPoint = $0 }
        leadingSegmentAppearance?.gradient.endPoint.map { leadingGradientDrawingView.customLayer.endPoint = $0 }
        leadingSegmentAppearance?.gradient.type.map { leadingGradientDrawingView.customLayer.type = $0 }

        // MARK: - Configuring `leadingSplineDrawingView`

        leadingSplineDrawingView.customLayer.lineWidth = settings.lineWidth
        leadingSplineDrawingView.customLayer.lineCap = settings.lineCapType.toCAShapeLayerLineCap()
        leadingSplineDrawingView.customLayer.path = path
        leadingSplineDrawingView.customLayer.strokeColor = leadingSegmentAppearance?.lineColor.cgColor

        // MARK: - Configuring `leadingHostingView`

        leadingHostingView.layer.mask = nil

        // MARK: - Configuring `trailingGradientDrawingView`

        trailingGradientDrawingView.customLayer.colors = nil
        trailingGradientDrawingView.layer.mask = nil

        // MARK: - Configuring `trailingSplineDrawingView`

        trailingSplineDrawingView.customLayer.path = nil

        // MARK: - Configuring `trailingHostingView`

        trailingHostingView.layer.mask = nil
    }

    private func makeGradientMaskPath(from path: CGPath, bounds: CGRect) -> CGPath {
        let maskPath = path.mutableCopy()!
        maskPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        maskPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        maskPath.closeSubpath()

        return maskPath
    }

    private func setupSubviews() {
        // gradient drawing views must lay underneath spline drawing views in order to stroke splines using proper color
        setupSubview(leadingHostingView, installOn: self)
        setupSubview(leadingGradientDrawingView, installOn: leadingHostingView)
        setupSubview(leadingSplineDrawingView, installOn: leadingHostingView)

        setupSubview(trailingHostingView, installOn: self)
        setupSubview(trailingGradientDrawingView, installOn: trailingHostingView)
        setupSubview(trailingSplineDrawingView, installOn: trailingHostingView)
    }

    private func setupSubview(_ subview: UIView, installOn view: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor),
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Factory methods

private extension ColorSplitLineChartCoreAnimationDrawingView {
    private static func makeSplineDrawingView() -> SplineDrawingView {
        let drawingView = SplineDrawingView()

        drawingView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.isUserInteractionEnabled = false
        drawingView.customLayer.fillColor = UIColor.clear.cgColor

        return drawingView
    }

    private static func makeGradientDrawingView() -> GradientDrawingView {
        let drawingView = GradientDrawingView()

        drawingView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.isUserInteractionEnabled = false

        return drawingView
    }

    private static func makeMaskLayer() -> CAShapeLayer {
        let maskLayer = CAShapeLayer()

        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor

        return maskLayer
    }
}
