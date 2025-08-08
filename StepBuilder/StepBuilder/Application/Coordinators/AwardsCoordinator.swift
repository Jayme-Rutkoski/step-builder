//
//  AwardsCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/7/25.
//

import Foundation
import UIKit

class AwardsCoordinator {
    
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func start() {
        let vc = getViewController()

        self.viewController.show(vc, sender: nil)
    }
    
    public func getViewController() -> UIViewController {
        let vc = AwardsViewController()
        
        return vc
    }
}
