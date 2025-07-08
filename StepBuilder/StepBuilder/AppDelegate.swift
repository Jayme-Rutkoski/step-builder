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
        
        let vc = HomeViewController()
        vc.setScene(scene: IsometricScene())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: statusBarFrame.width, height: window?.safeAreaInsets.top ?? statusBarFrame.height))
            statusBar.backgroundColor = .white
            window?.addSubview(statusBar)
        }
        
        if (SwiftAppDefaults.shared.installDate == Date(timeIntervalSince1970: 0)) {
            SwiftAppDefaults.shared.installDate = .now
        }
        
        return true
    }

}

