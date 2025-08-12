//
//  NotificationName.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/6/25.
//


import Foundation

public extension Notification.Name {
    static let CurrencyUpdate: NSNotification.Name = Notification.Name("Notification.Name.CurrencyUpdate")
    static let MonsterFound: NSNotification.Name = Notification.Name("Notification.Name.MonsterFound")
    static let ItemConsumed: NSNotification.Name = Notification.Name("Notification.Name.ItemConsumed")
}
