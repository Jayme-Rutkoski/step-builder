//
//  SwiftAppDefaults.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/7/25.
//


import Foundation

protocol SwiftAppDefaultsProtocol {
    var installDate: Date { get set }
}

public class SwiftAppDefaults: SwiftAppDefaultsProtocol {
    
    public static let shared: SwiftAppDefaults = {
        return SwiftAppDefaults()
    }()
    
    private var defaults: UserDefaults
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    private struct Keys {
        public static let installDate = "AppDefaults.Keys.installDate"
        public static let lastOpened = "AppDefaults.Keys.lastOpened"
        public static let lastPerfectStreak = "AppDefaults.Keys.lastPerfectStreak"
        public static let shownOnboarding = "AppDefaults.Keys.shownOnboarding"
        public static let userId = "AppDefaults.Keys.userId"
        public static let coins = "AppDefaults.Keys.coins"
        public static let newMonsters = "AppDefaults.Keys.newMonsters"
        public static let monstersFound = "AppDefaults.Keys.monstersFound"
        public static let monsterDex = "AppDefaults.Keys.monsterDex"
        public static let monsterInventory = "AppDefaults.Keys.monsterInventory"
        public static let itemInventory = "AppDefaults.Keys.itemInventory"
        public static let lastDailyGiftDate = "AppDefaults.Keys.lastDailyGiftDate"
        public static let showMonsterFindSummary = "AppDefaults.Keys.showMonsterFindSummary"
        public static let virtualStepsHistory = "AppDefaults.Keys.virtualStepsHistory"
        public static let hasMonsterBaitActive = "AppDefaults.Keys.hasMonsterBaitActive"
        public static let hasStepAmplifierActive = "AppDefaults.Keys.hasStepAmplifierActive"
        public static let hasLuckyCharmActive = "AppDefaults.Keys.hasLuckyCharmActive"
        
        // Achievements
        public static let monsterFindCount = "AppDefaults.Keys.monsterFindCount"
        public static let uniqueMonsterFindCount = "AppDefaults.Keys.uniqueMonsterFindCount"
        public static let totalStepsTaken = "AppDefaults.Keys.totalStepsTaken"
        public static let totalItemsBought = "AppDefaults.Keys.totalItemsBought"
        public static let loginStreakCount = "AppDefaults.Keys.loginStreakCount"
        public static let has7DayLoginStreak = "AppDefaults.Keys.has7DayLoginStreak"
        public static let has14DayLoginStreak = "AppDefaults.Keys.has14DayLoginStreak"
        public static let has30DayLoginStreak = "AppDefaults.Keys.has30DayLoginStreak"
        public static let perfectStreakCount = "AppDefaults.Keys.perfectStreakCount"
        public static let hasPerfectDay = "AppDefaults.Keys.hasPerfectDay"
        public static let hasPerfectWeek = "AppDefaults.Keys.hasPerfectWeek"
        public static let hasPerfectMonth = "AppDefaults.Keys.hasPerfectMonth"
    }
    
    public var installDate: Date {
        get {
            return Date(timeIntervalSince1970: defaults.double(forKey: Keys.installDate))
        }
        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.installDate)
        }
    }
    
    public var lastOpened: Date {
        get {
            return Date(timeIntervalSince1970: defaults.double(forKey: Keys.lastOpened))
        }
        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.lastOpened)
        }
    }
    
    public var lastPerfectStreak: Date {
        get {
            return Date(timeIntervalSince1970: defaults.double(forKey: Keys.lastPerfectStreak))
        }
        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.lastPerfectStreak)
        }
    }
    
    public var shownOnboarding: Bool {
        get {
            return defaults.bool(forKey: Keys.shownOnboarding)
        }
        set {
            defaults.set(newValue, forKey: Keys.shownOnboarding)
        }
    }
    
    public var userId: String? {
        get {
            return defaults.string(forKey: Keys.userId)
        } set {
            defaults.safe(set: newValue, forKey: Keys.userId)
        }
    }
    
    public var coins: Int {
        get {
            return defaults.integer(forKey: Keys.coins)
        } set {
            defaults.set(newValue, forKey: Keys.coins)
        }
    }
    
    public var newMonsters: [Int] {
        get {
            return defaults.array(forKey: Keys.newMonsters) as? [Int] ?? []
        }
        set {
            defaults.set(newValue, forKey: Keys.newMonsters)
        }
    }
    
    public var monstersFound: [Int] {
        get {
            return defaults.array(forKey: Keys.monstersFound) as? [Int] ?? []
        }
        set {
            defaults.set(newValue, forKey: Keys.monstersFound)
        }
    }
    
    public var monsterInventory: [Int] {
        get {
            return defaults.array(forKey: Keys.monsterInventory) as? [Int] ?? []
        }
        set {
            defaults.set(newValue, forKey: Keys.monsterInventory)
        }
    }
    
    public var itemInventory: [Int] {
        get {
            return defaults.array(forKey: Keys.itemInventory) as? [Int] ?? []
        }
        set {
            defaults.set(newValue, forKey: Keys.itemInventory)
        }
    }
    
    public var monsterDex: [Int] {
        get {
            return defaults.array(forKey: Keys.monsterDex) as? [Int] ?? []
        }
        set {
            defaults.set(newValue, forKey: Keys.monsterDex)
        }
    }
    
    public var lastDailyGiftDate: Date {
        get {
            return Date(timeIntervalSince1970: defaults.double(forKey: Keys.lastDailyGiftDate))
        }
        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.lastDailyGiftDate)
        }
    }
    
    public var monsterFindCount: Int {
        get {
            return defaults.integer(forKey: Keys.monsterFindCount)
        }
        set {
            defaults.set(newValue, forKey: Keys.monsterFindCount)
        }
    }
    
    public var uniqueMonsterFindCount: Int {
        get {
            return defaults.integer(forKey: Keys.uniqueMonsterFindCount)
        }
        set {
            defaults.set(newValue, forKey: Keys.uniqueMonsterFindCount)
        }
    }
    
    public var totalStepsTaken: Int {
        get {
            return defaults.integer(forKey: Keys.totalStepsTaken)
        }
        set {
            defaults.set(newValue, forKey: Keys.totalStepsTaken)
        }
    }
    
    public var totalItemsBought: Int {
        get {
            return defaults.integer(forKey: Keys.totalItemsBought)
        }
        set {
            defaults.set(newValue, forKey: Keys.totalItemsBought)
        }
    }
    
    public var loginStreakCount: Int {
        get {
            return defaults.integer(forKey: Keys.loginStreakCount)
        }
        set {
            defaults.set(newValue, forKey: Keys.loginStreakCount)
        }
    }
    
    public var showMonsterFindSummary: Bool {
        get {
            return defaults.bool(forKey: Keys.showMonsterFindSummary)
        }
        set {
            defaults.set(newValue, forKey: Keys.showMonsterFindSummary)
        }
    }
    
    public var has7DayLoginStreak: Bool {
        get {
            return defaults.bool(forKey: Keys.has7DayLoginStreak)
        }
        set {
            defaults.set(newValue, forKey: Keys.has7DayLoginStreak)
        }
    }
    
    public var has14DayLoginStreak: Bool {
        get {
            return defaults.bool(forKey: Keys.has14DayLoginStreak)
        }
        set {
            defaults.set(newValue, forKey: Keys.has14DayLoginStreak)
        }
    }
    
    public var has30DayLoginStreak: Bool {
        get {
            return defaults.bool(forKey: Keys.has30DayLoginStreak)
        }
        set {
            defaults.set(newValue, forKey: Keys.has30DayLoginStreak)
        }
    }
    
    public var perfectStreakCount: Int {
        get {
            return defaults.integer(forKey: Keys.perfectStreakCount)
        }
        set {
            defaults.set(newValue, forKey: Keys.perfectStreakCount)
        }
    }
    
    public var hasPerfectDay: Bool {
        get {
            return defaults.bool(forKey: Keys.hasPerfectDay)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasPerfectDay)
        }
    }
    
    public var hasPerfectWeek: Bool {
        get {
            return defaults.bool(forKey: Keys.hasPerfectWeek)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasPerfectWeek)
        }
    }
    
    public var hasPerfectMonth: Bool {
        get {
            return defaults.bool(forKey: Keys.hasPerfectMonth)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasPerfectMonth)
        }
    }
    
    public var virtualStepsHistory: [Date: Int] {
        get {
            guard let data = defaults.data(forKey: Keys.virtualStepsHistory),
                  let decoded = try? JSONDecoder().decode([Date: Int].self, from: data) else { return [:] }
            return decoded
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                defaults.set(encoded, forKey: Keys.virtualStepsHistory)
            }
        }
    }
    
    public var hasMonsterBaitActive: Bool {
        get {
            return defaults.bool(forKey: Keys.hasMonsterBaitActive)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasMonsterBaitActive)
        }
    }
    
    public var hasStepAmplifierActive: Bool {
        get {
            return defaults.bool(forKey: Keys.hasStepAmplifierActive)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasStepAmplifierActive)
        }
    }
    
    public var hasLuckyCharmActive: Bool {
        get {
            return defaults.bool(forKey: Keys.hasLuckyCharmActive)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasLuckyCharmActive)
        }
    }
    
    public static func addMonster(_ id: Int) {
        var monsterDex = SwiftAppDefaults.shared.monsterDex
        var monstersFound = SwiftAppDefaults.shared.monstersFound
        var monsterInventory = SwiftAppDefaults.shared.monsterInventory
        var newMonsters = SwiftAppDefaults.shared.newMonsters
        
        if (!monsterDex.contains(id)) {
            monsterDex.append(id)
            newMonsters.append(id)
            SwiftAppDefaults.shared.uniqueMonsterFindCount += 1
        }
        
        monstersFound.append(id)
        SwiftAppDefaults.shared.monsterFindCount += 1
        
        monsterInventory.append(id)
        monsterInventory.sort() { $0 < $1 }

        SwiftAppDefaults.shared.monsterDex = monsterDex
        SwiftAppDefaults.shared.monstersFound = monstersFound
        SwiftAppDefaults.shared.monsterInventory = monsterInventory
        SwiftAppDefaults.shared.newMonsters = newMonsters
    }
    
    public static func removeMonster(_ id: Int) {
        var monsters = SwiftAppDefaults.shared.monstersFound
        var newMonsters = SwiftAppDefaults.shared.newMonsters
        
        if (monsters.contains(id)) {
            monsters.firstIndex(where: { $0 == id }).map { monsters.remove(at: $0) }
            newMonsters.firstIndex(where: { $0 == id }).map { newMonsters.remove(at: $0) }
        }
        SwiftAppDefaults.shared.monstersFound = monsters
        SwiftAppDefaults.shared.newMonsters = newMonsters
    }
    
    public static func removeAllMonsters() {
        var monsters = SwiftAppDefaults.shared.monstersFound
        var newMonsters = SwiftAppDefaults.shared.newMonsters
        monsters.removeAll()
        newMonsters.removeAll()
        SwiftAppDefaults.shared.monstersFound = monsters
        SwiftAppDefaults.shared.newMonsters = newMonsters
    }
    
    public static func addShopItem(_ id: Int) {
        var itemInventory = SwiftAppDefaults.shared.itemInventory
        itemInventory.append(id)
        SwiftAppDefaults.shared.itemInventory = itemInventory
    }
    
    public static func consumeShopItem(_ id: Int) {
        var itemInventory = SwiftAppDefaults.shared.itemInventory
        if (itemInventory.contains(id)) {
            itemInventory.firstIndex(where: { $0 == id }).map { itemInventory.remove(at: $0) }
        }
        SwiftAppDefaults.shared.itemInventory = itemInventory
    }
}

fileprivate extension UserDefaults {
    
    // String
    func safe(set value: String?, forKey: String) {
        
        guard let value = value else {
            self.removeObject(forKey: forKey)
            return
        }
        
        self.set(value, forKey: forKey)
    }
    
}
