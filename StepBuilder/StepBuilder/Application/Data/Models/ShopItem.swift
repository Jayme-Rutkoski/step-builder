//
//  ShopItem.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/8/25.
//

import Foundation

class ShopItem: Codable {
    var name: String
    var price: Int
    var itemNumber: Int
    
    init(name: String, price: Int, itemNumber: Int) {
        self.name = name
        self.price = price
        self.itemNumber = itemNumber
    }
}
