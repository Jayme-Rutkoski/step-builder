//
//  Factory.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/24/25.
//
import CoreMotion

class Factory {
    
    private static var sharedFactory: Factory = {
        return Factory()
    }()
    
    class func shared() -> Factory {
        return sharedFactory
    }
    
    public static func resetFactory() {
        sharedFactory = Factory()
    }
    
    private var _shopItems: [ShopItem]? = nil
    public var shopItems: [ShopItem] {
        get {
            if _shopItems == nil {
                _shopItems = try! NetworkHelper.load("ShopItems.json")
            }
            return _shopItems!
        }
    }
    
    private var _monsters: [Monster]? = nil
    public var monsters: [Monster] {
        get {
            if _monsters == nil {
                _monsters = try! NetworkHelper.load("Monsters.json")
            }
            return _monsters!
        }
    }
    
    private var _stepProgressManager: StepProgressManager? = nil
    public var stepProgressManager: StepProgressManager {
        get {
            if _stepProgressManager == nil {
                _stepProgressManager = StepProgressManager()
            }
            return _stepProgressManager!
        }
    }
    
    private var _pedometer: CMPedometer? = nil
    public var pedometer: CMPedometer {
        get {
            if _pedometer == nil {
                _pedometer = CMPedometer()
            }
            return _pedometer!
        }
    }
    
    private var _usersCollection: UsersCollection? = nil
    public var usersCollection: UsersCollection {
        get {
            if _usersCollection == nil {
                _usersCollection = UsersCollection()
            }
            return _usersCollection!
        }
    }
}
