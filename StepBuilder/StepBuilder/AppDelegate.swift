//
//  AppDelegate.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/7/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: statusBarFrame.width, height: window?.safeAreaInsets.top ?? statusBarFrame.height))
            statusBar.backgroundColor = .white
            window?.addSubview(statusBar)
        }
        
        return true
    }

}

