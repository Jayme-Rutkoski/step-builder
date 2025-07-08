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
    }
    
    public var installDate: Date {
        get {
            return Date(timeIntervalSince1970: defaults.double(forKey: Keys.installDate))
        }
        set {
            defaults.set(newValue.timeIntervalSince1970, forKey: Keys.installDate)
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
