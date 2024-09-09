//
//  LineChartPathHandler.swift
//  Tangem
//
//  Created by Andrey Fedorov on 22.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol LineChartPathHandler: AnyObject {
    func handlePath(_ path: CGPath, with settings: LineChartDrawingPathSettings, dataSet: LineChartDataSetProtocol)
}
