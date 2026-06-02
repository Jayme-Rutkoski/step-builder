//
//  ItemHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/12/25.
//
import Foundation
import UIKit

enum ItemType: Int {
    case EnergyDrink = 10000
    case MonsterBait = 10001
    case StepAmplifier = 10002
    case LuckyCharm = 10003
}
class ItemHelper {
    
    static func consumeItem(_ itemNumber: Int) {
        let consume = {
            SwiftAppDefaults.consumeShopItem(itemNumber)
            NotificationCenter.default.post(name: .ItemConsumed, object: itemNumber)
        }
        
        if (itemNumber == ItemType.EnergyDrink.rawValue) {
            consumeEnergyDrink() {
                consume()
            }
        } else if (itemNumber == ItemType.MonsterBait.rawValue) {
            consumeMonsterBait()  {
                consume()
            }
        } else if (itemNumber == ItemType.StepAmplifier.rawValue) {
            consumeStepAmplifier() {
                consume()
            }
        } else if (itemNumber == ItemType.LuckyCharm.rawValue) {
            consumeLuckyCharm() {
                consume()
            }
        } else {
            print("FAILED")
            return
        }
    }
    
    static func consumeEnergyDrink(completion: @escaping () -> Void = {}) {
        let newSteps = 500
        var virtualSteps = SwiftAppDefaults.shared.virtualStepsHistory[Date.now]
        virtualSteps = (virtualSteps ?? 0) + newSteps
        SwiftAppDefaults.shared.virtualStepsHistory[Date.now] = virtualSteps
        SwiftAppDefaults.shared.totalStepsTaken += newSteps
        NotificationCenter.default.post(name: .UpdateSteps, object: newSteps)
        completion()
    }
    
    static func consumeMonsterBait(completion: @escaping () -> Void = {}) {
        if (SwiftAppDefaults.shared.hasMonsterBaitActive) {
            showMessage(title: "Cannot Use Monster Bait", message: "You already have an active Monster Bait. Please use the current one before using another.")
        } else {
            SwiftAppDefaults.shared.hasMonsterBaitActive = true
            completion()
        }
    }
    
    static func consumeStepAmplifier(completion: @escaping () -> Void = {}) {
        if (SwiftAppDefaults.shared.hasStepAmplifierActive) {
            showMessage(title: "Cannot Use Step Amplifier", message: "You already have an active Step Amplifier. Please use the current one before using another.")
        } else {
            SwiftAppDefaults.shared.hasStepAmplifierActive = true
            completion()
        }
    }
    
    static func consumeLuckyCharm(completion: @escaping () -> Void = {}) {
        if (SwiftAppDefaults.shared.hasLuckyCharmActive) {
            showMessage(title: "Cannot Use Lucky Charm", message: "You already have an active Lucky Charm. Please use the current one before using another.")
        } else {
            SwiftAppDefaults.shared.hasLuckyCharmActive = true
            completion()
        }
    }
    
    private static func showMessage(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            //RootViewController.shared.dismiss(animated: true)
        }))
        
        RootViewController.shared.show(alertVC, sender: nil)
    }
}
