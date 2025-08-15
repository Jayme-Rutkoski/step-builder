//
//  AppDelegate.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/7/25.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        SwiftAppDefaults.shared.showMonsterFindSummary = true
        print("SHOW SUMMARY: \(SwiftAppDefaults.shared.showMonsterFindSummary)")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController.shared
        window?.makeKeyAndVisible()
        
        if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: statusBarFrame.width, height: window?.safeAreaInsets.top ?? statusBarFrame.height))
            statusBar.backgroundColor = .white
            window?.addSubview(statusBar)
        }
        
        if (SwiftAppDefaults.shared.installDate == Date(timeIntervalSince1970: 0)) {
            SwiftAppDefaults.shared.installDate = .now
        }
        
        if (SwiftAppDefaults.shared.lastOpened == Date(timeIntervalSince1970: 0)) {
            SwiftAppDefaults.shared.loginStreakCount = 1
        } else {
            let lastOpened = SwiftAppDefaults.shared.lastOpened
            if (lastOpened.isSameDay(as: Date.now.getPastDate(byDays: 1)!)) {
                SwiftAppDefaults.shared.loginStreakCount += 1
                if (SwiftAppDefaults.shared.has7DayLoginStreak == false && SwiftAppDefaults.shared.loginStreakCount >= 7) {
                    SwiftAppDefaults.shared.has7DayLoginStreak = true
                    // Post notification
                } else if (SwiftAppDefaults.shared.has14DayLoginStreak == false && SwiftAppDefaults.shared.loginStreakCount >= 14) {
                    SwiftAppDefaults.shared.has14DayLoginStreak = true
                    // Post notification
                } else if (SwiftAppDefaults.shared.has30DayLoginStreak == false && SwiftAppDefaults.shared.loginStreakCount >= 30) {
                    SwiftAppDefaults.shared.has30DayLoginStreak = true
                    // Post notification
                }
            } else if (!lastOpened.isSameDay(as: Date.now)) {
                SwiftAppDefaults.shared.loginStreakCount = 1
            }
        }
        
        SwiftAppDefaults.shared.lastOpened = .now
        
        MainCoordinator().start()
        
        if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: statusBarFrame.width, height: window?.safeAreaInsets.top ?? statusBarFrame.height))
            statusBar.backgroundColor = UIColor(hex: 0xa64ca6)
            window?.addSubview(statusBar)
        }
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        SwiftAppDefaults.shared.showMonsterFindSummary = true
    }
}

