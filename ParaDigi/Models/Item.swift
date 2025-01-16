//
//  Item.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/1/16.
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
