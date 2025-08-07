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
    
    public init() {
        self.defaults = UserDefaults.standard
    }
    private struct Keys {
        public static let installDate = "AppDefaults.Keys.installDate"
        public static let shownOnboarding = "AppDefaults.Keys.shownOnboarding"
        public static let userId = "AppDefaults.Keys.userId"
        public static let coins = "AppDefaults.Keys.coins"
        public static let monstersFound = "AppDefaults.Keys.monstersFound"
    }
    
    public var installDate: Date {
        get {
            return Date(timeIntervalSince1970: defaults.double(forKey: Keys.installDate))
        }
        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.installDate)
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
    
    public var monstersFound: [Int] {
        get {
            return defaults.array(forKey: Keys.monstersFound) as? [Int] ?? []
        }
        set {
            defaults.set(newValue, forKey: Keys.monstersFound)
        }
    }
    
    public static func addMonster(_ id: Int) {
        var monsters = SwiftAppDefaults.shared.monstersFound
        monsters.append(id)
        SwiftAppDefaults.shared.monstersFound = monsters
        
    }
    
    public static func removeMonster(_ id: Int) {
        var monsters = SwiftAppDefaults.shared.monstersFound
        if let index = monsters.firstIndex(of: id) {
            monsters.remove(at: index)
            SwiftAppDefaults.shared.monstersFound = monsters
        }
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
