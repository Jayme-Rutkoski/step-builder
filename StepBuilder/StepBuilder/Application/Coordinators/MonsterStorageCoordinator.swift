//
//  MonsterStorageCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 4/1/2026.
//

import Foundation
import UIKit

class MonsterStorageCoordinator {
    
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func start() {
        let vc = getViewController()

        self.viewController.show(vc, sender: nil)
    }
    
    public func getViewController() -> UIViewController {
        let vc = MonsterStorageViewController()
        
        return vc
    }
}
