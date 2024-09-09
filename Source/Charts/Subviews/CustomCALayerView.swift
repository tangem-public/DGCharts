//
//  CustomCALayerView.swift
//  Tangem
//
//  Created by Andrey Fedorov on 22.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import UIKit

final class CustomCALayerView<Layer>: UIView where Layer: CALayer {
    override class var layerClass: AnyClass { Layer.self }

    var customLayer: Layer { layer as! Layer }
}
