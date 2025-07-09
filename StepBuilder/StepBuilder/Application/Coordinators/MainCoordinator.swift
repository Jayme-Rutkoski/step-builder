//
//  MainCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//

import Foundation
import UIKit

class MainCoordinator {
    
    init() {
        
    }
    
    public func start() {
        RootViewController.shared.update(to: SplashViewController())
        
        continueToApp()
    }
    
    func continueToApp() {
        if (SwiftAppDefaults.shared.shownOnboarding == false) {
            self.navigateToOnboarding()
        } else {
            self.navigateIntoApp()
        }
    }
    
    func navigateIntoApp() {
        DispatchQueue.main.async {
            TabBarCoordinator().start()
        }
    }
        
    func navigateToOnboarding() {
        let vc = OnboardingViewController {
            Task.init {
                SwiftAppDefaults.shared.shownOnboarding = true
    
                self.navigateIntoApp()
            }
        }
        
        DispatchQueue.main.async {
            RootViewController.shared.update(to: UINavigationController(rootViewController: vc))
        }
    }
}

