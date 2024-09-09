//
//  ColorSplitLineChartContainerViewController.swift
//  Tangem
//
//  Created by Andrey Fedorov on 22.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import UIKit

public final class ColorSplitLineChartContainerViewController: UIViewController {
    public weak var delegate: ColorSplitLineChartContainerViewControllerDelegate?

    public private(set) lazy var lineChartView = LineChartView()

    private lazy var coreAnimationDrawingView = ColorSplitLineChartCoreAnimationDrawingView()

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        // `coreAnimationDrawingView` must lie underneath the `lineChartView` for the chart to be drawn correctly
        setupSubview(coreAnimationDrawingView)
        setupSubview(lineChartView)
    }

    private func setupSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subview.topAnchor.constraint(equalTo: view.topAnchor),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - LineChartPathHandler protocol conformance

extension ColorSplitLineChartContainerViewController: LineChartPathHandler {
    public func handlePath(_ path: CGPath, with settings: LineChartDrawingPathSettings, dataSet: LineChartDataSetProtocol) {
        let lastHighlightedPoint: CGPoint?
        let leadingSegmentAppearance: ColorSplitLineChartSegmentAppearance?
        let trailingSegmentAppearance: ColorSplitLineChartSegmentAppearance?

        if let lastHighlighted = lineChartView.lastHighlighted, let highlightedEntry = dataSet.entryForXValue(
            lastHighlighted.x,
            closestToY: lastHighlighted.y,
            rounding: .closest
        ) {
            lastHighlightedPoint = CGPoint(x: lastHighlighted.drawX, y: lastHighlighted.drawY)
            leadingSegmentAppearance = delegate?.segmentAppearanceBefore(
                highlightedEntry: highlightedEntry,
                highlight: lastHighlighted,
                viewController: self
            )
            trailingSegmentAppearance = delegate?.segmentAppearanceAfter(
                highlightedEntry: highlightedEntry,
                highlight: lastHighlighted,
                viewController: self
            )
        } else {
            lastHighlightedPoint = nil
            leadingSegmentAppearance = delegate?.defaultSegmentAppearance(viewController: self)
            trailingSegmentAppearance = nil
        }

        coreAnimationDrawingView.setDrawingPath(
            path,
            settings: settings,
            leadingSegmentAppearance: leadingSegmentAppearance,
            trailingSegmentAppearance: trailingSegmentAppearance,
            lastHighlightedPoint: lastHighlightedPoint
        )
    }
}
