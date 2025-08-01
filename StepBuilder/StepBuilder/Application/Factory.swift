//
//  Factory.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/24/25.
//

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
    
    private var _stepProgressManager: StepProgressManager? = nil
    public var stepProgressManager: StepProgressManager {
        get {
            if _stepProgressManager == nil {
                _stepProgressManager = StepProgressManager()
            }
            return _stepProgressManager!
        }
    }
    
}
