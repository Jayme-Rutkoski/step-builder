//
//  MonsterCollectionHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 6/1/2026.
//
import Foundation

public class MonsterCollectionHelper {
    private static let collectionKey = "monster_collection"
    
    // MARK: - Save or Update a Single Monster
    static func saveMonster(_ monster: Monster) {
        // 1. Load the existing collection dictionary (or start a fresh one)
        var collection = loadAllMonstersDictionary()
        
        // 2. Insert or update ONLY this specific monster using its ID string
        collection[monster.id] = monster
        
        // 3. Save the updated dictionary back to UserDefaults
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(collection) {
            UserDefaults.standard.set(encodedData, forKey: collectionKey)
            print("Successfully updated \(monster.name) in the collection!")
        }
    }
    
    // MARK: - Load the Full Dictionary (Internal Helper)
    private static func loadAllMonstersDictionary() -> [Int: Monster] {
        let updateWithMonsterInventory: ([Int: Monster]) -> [Int: Monster] = { result in
            let monsterInventory = MonsterHelper.getUniqueMonsters(SwiftAppDefaults.shared.monsterInventory)
            var result = result

            for monster in monsterInventory {
                if !(result.keys.contains(monster.id)) {
                    result[monster.id] = monster
                }
            }
            return result
        }
        
        guard let savedData = UserDefaults.standard.data(forKey: collectionKey) else {
            return updateWithMonsterInventory([:])
        }
        
        let monsterInventory = SwiftAppDefaults.shared.monsterInventory
        
        let decoder = JSONDecoder()
        var result = (try? decoder.decode([Int: Monster].self, from: savedData)) ?? [:]
        
        return updateWithMonsterInventory(result)
    }
    
    // MARK: - Get All Monsters as an Array (For your UI/Lists)
    static func loadAllMonsters() -> [Monster] {
        let collection = loadAllMonstersDictionary()
        // Just return the values of the dictionary as a clean array
        return Array(collection.values)
    }
}
