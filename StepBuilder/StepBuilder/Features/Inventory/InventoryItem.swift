//
//  InventoryItem.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/12/25.
//

class InventoryItem {
    var name: String
    var price: Int
    var itemNumber: Int
    var desc: String
    var quantity: Int
    
    init(name: String, price: Int, itemNumber: Int, desc: String, quantity: Int = 1) {
        self.name = name
        self.price = price
        self.itemNumber = itemNumber
        self.desc = desc
        self.quantity = quantity
    }
}
