//
//  MainCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//

import Foundation
import UIKit
import FirebaseAuth

class MainCoordinator {
    
    init() {
        
    }
    
    public func start() {
        RootViewController.shared.update(to: SplashViewController())
        Factory.shared().stepProgressManager.initializeAndLoadProgress {
            if (SwiftAppDefaults.shared.userId == nil || SwiftAppDefaults.shared.userId?.isEmpty == true) {
                Task {
                    do {
                        let auth = Auth.auth()
                        _ = try await auth.signInAnonymously()
                        SwiftAppDefaults.shared.userId = auth.currentUser?.uid
                        self.continueToApp()
                    } catch {
                        print("Error signing in anonymously: \(error.localizedDescription)")
                    }
                }
            } else {
                self.continueToApp()
            }
        }
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
        DispatchQueue.main.async {
            let vc = OnboardingViewController {
                Task.init {
                    SwiftAppDefaults.shared.shownOnboarding = true
        
                    self.navigateIntoApp()
                }
            }
            
            RootViewController.shared.update(to: UINavigationController(rootViewController: vc))
        }
    }
}

