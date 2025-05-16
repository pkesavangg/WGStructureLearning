//
//  Item.swift
//  WG_Structure_Learning
//
//  Created by Kesavan Panchabakesan on 15/05/25.
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
