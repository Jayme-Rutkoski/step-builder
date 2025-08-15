//
//  MonsterSummary.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/13/25.
//


import Foundation

class MonsterSummary {
    var monster: Monster
    var quantity: Int
    var isNew: Bool
    
    init(monster: Monster, quantity: Int, isNew: Bool) {
        self.monster = monster
        self.quantity = quantity
        self.isNew = isNew
    }
}
