//
//  Collection+.swift
//  Tangem
//
//  Created by Andrey Fedorov on 01.08.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

extension Swift.Collection {
    var nilIfEmpty: Self? {
        return isEmpty ? nil : self
    }
}
