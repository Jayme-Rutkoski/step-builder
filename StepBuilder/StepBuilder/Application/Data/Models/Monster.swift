//
//  Monster.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//
import Foundation

public class Monster: Codable {
    var id: Int = 0
    var name: String = ""
    var rarity: Rarity = .common
    var currentLevel: Int? = 1
    
    init() { }
}

public enum Rarity: Int, Codable {
    case common = 1, uncommon = 2, rare = 3, legendary = 4
        
    // Controls how many shards are required based on scarcity
    var shardFactor: Double {
        switch self {
        case .common:    return 2.0  // Needs the most shards
        case .uncommon:  return 1.5
        case .rare:      return 1.0
        case .legendary: return 0.5  // Needs very few shards
        }
    }
}
