//
//  MonsterHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/6/25.
//
import Foundation

public class MonsterHelper {
    static func getCommonMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == .common }.map { $0.id }
    }
    
    static func getUncommonMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == .uncommon }.map { $0.id }
    }
    
    static func getRareMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == .rare }.map { $0.id }
    }
    
    static func getLegendaryMonsters() -> [Int] {
        return Factory.shared().monsters.filter { $0.rarity == .legendary }.map { $0.id }
    }
    
    static func getMonster() -> Int {
        let randomValue = Int.random(in: 0..<100)
        var monsterFound = 99999
        var luckyChanceFind = 1
        if SwiftAppDefaults.shared.hasLuckyCharmActive {
            luckyChanceFind = 2
            SwiftAppDefaults.shared.hasLuckyCharmActive = false
        }
        
        
        switch randomValue {
        case 0..<(3*luckyChanceFind):
            monsterFound = getLegendaryMonsters().randomElement() ?? monsterFound
            break
        case (3*luckyChanceFind)..<(13*luckyChanceFind):
            monsterFound = getRareMonsters().randomElement() ?? monsterFound
            break
        case 13..<33:
            monsterFound = getUncommonMonsters().randomElement() ?? monsterFound
            break
        case 33..<83:
            monsterFound = getCommonMonsters().randomElement() ?? monsterFound
            break
        default:
            monsterFound = 99999
        }
        
        return monsterFound
    }

    static func calculateNewFind() -> Int {
        var monsterFound = getMonster()
        
        if (SwiftAppDefaults.shared.hasMonsterBaitActive) {
            while monsterFound == 99999 {
                monsterFound = getMonster()
            }
            
            SwiftAppDefaults.shared.hasMonsterBaitActive = false
        }
        
        guard monsterFound != 99999 else { return monsterFound }
            
        SwiftAppDefaults.addMonster(monsterFound)
        NotificationCenter.default.post(name: .MonsterFound, object: monsterFound)
        return monsterFound
    }
    
    static func getUniqueMonsters(_ monsterIds: [Int]) -> [Monster] {
        return Factory.shared().monsters.filter { monsterIds.contains($0.id) }
    }
    static func getMonsterByID(_ id: Int) -> Monster? {
        return Factory.shared().monsters.first { $0.id == id }
    }
    static func getAllMonsterInventoryIDsByID(_ id: Int) -> [Int] {
        return SwiftAppDefaults.shared.monsterInventory.filter { $0 == id }
    }
    static func removeMonsterInventoryIDsByIDAndAmount(_ id: Int, amount: Int) {
        SwiftAppDefaults.shared.monsterInventory.remove(amount: amount, where: { $0 == id })
    }
}
