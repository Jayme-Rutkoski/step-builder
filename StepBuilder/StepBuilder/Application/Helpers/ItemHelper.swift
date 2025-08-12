//
//  ItemHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/12/25.
//
import Foundation

class ItemHelper {
    
    static func consumeItem(_ itemNumber: Int) {
        SwiftAppDefaults.consumeShopItem(itemNumber)
        NotificationCenter.default.post(name: .ItemConsumed, object: itemNumber)
    }
}
