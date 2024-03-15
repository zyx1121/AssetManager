//
//  Item.swift
//  AssetManager
//
//  Created by Loki on 3/15/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
