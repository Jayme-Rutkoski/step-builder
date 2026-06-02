//
//  LevelHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 6/1/2026.
//

import Foundation

enum LevelRank: Int {
    case novice = 1
    case trained = 2
    case elite = 3
    case legendary = 4
}

public class LevelHelper {
    // Starting point: an absolute base number of shards needed to go from Level 1 -> 2
    private static let baseShards: Double = 2.0
    
    /// Calculates exactly how many shards are required to upgrade from the CURRENT level to the NEXT level.
    static func shardsRequiredForNextLevel(fromCurrentLevel level: Int, rarity: Rarity) -> Int {
        let rawShards = baseShards * Double(level) * rarity.shardFactor
        return max(1, Int(round(rawShards)))
    }
    
    /// Calculates how many shards were required to reach the CURRENT level from the previous one.
    static func shardsRequiredForCurrentLevel(currentLevel level: Int, rarity: Rarity) -> Int {
        // If they are level 1, they haven't leveled up yet, so it cost 0 shards.
        guard level > 1 else { return 0 }
        
        // Look backward by 1 level
        return shardsRequiredForNextLevel(fromCurrentLevel: level - 1, rarity: rarity)
    }
    
    static func rank(forLevel level: Int) -> LevelRank {
            switch level {
            case 1...9:
                return .novice
            case 10...24:
                return .trained
            case 25...49:
                return .elite
            default:
                return .legendary
            }
        }
}
