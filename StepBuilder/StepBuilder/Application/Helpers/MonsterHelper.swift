//
//  MonsterHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/6/25.
//
import Foundation

class MonsterHelper {
    static func getCommonMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == 1 }.map { $0.id }
    }
    
    static func getUncommonMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == 2 }.map { $0.id }
    }
    
    static func getRareMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == 3 }.map { $0.id }
    }
    
    static func getLegendaryMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == 4 }.map { $0.id }
    }

    static func calculateNewFind() -> Int {
        var randomValue = Int.random(in: 0...100)
        if (randomValue <= 30) {
            // 30% chance to find nothing
            return 99999
        } else {
            randomValue = Int.random(in: 0...100)
            var monsterFound = 99999
            
            if (randomValue <= 3) { // 3% chance to find a legendary monster
                monsterFound = getLegendaryMonsters().randomElement() ?? 99999
            } else if (randomValue > 3 && randomValue <= 13) { // 10% chance to find a rare monster
                monsterFound = getRareMonsters().randomElement() ?? 99999
            } else if (randomValue > 13 && randomValue <= 43) { // 30% chance to find an uncommon monster
                monsterFound = getUncommonMonsters().randomElement() ?? 99999
            } else { // 57% change to find a common monster
                monsterFound = getCommonMonsters().randomElement() ?? 99999
            }
                
            SwiftAppDefaults.addMonster(monsterFound)
            NotificationCenter.default.post(name: .MonsterFound, object: monsterFound)
            return monsterFound
        }
    }
}
