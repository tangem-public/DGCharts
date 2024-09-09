//
//  ColorSplitLineChartContainerViewControllerDelegate.swift
//  Tangem
//
//  Created by Andrey Fedorov on 22.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

public protocol ColorSplitLineChartContainerViewControllerDelegate: AnyObject {
    /// `Default` means that no point is selected on the chart.
    func defaultSegmentAppearance(
        viewController: ColorSplitLineChartContainerViewController
    ) -> ColorSplitLineChartSegmentAppearance?

    func segmentAppearanceBefore(
        highlightedEntry: ChartDataEntry,
        highlight: Highlight,
        viewController: ColorSplitLineChartContainerViewController
    ) -> ColorSplitLineChartSegmentAppearance?

    func segmentAppearanceAfter(
        highlightedEntry: ChartDataEntry,
        highlight: Highlight,
        viewController: ColorSplitLineChartContainerViewController
    ) -> ColorSplitLineChartSegmentAppearance?
}
