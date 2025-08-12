//
//  InventoryCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//

import Foundation
import UIKit

class InventoryCoordinator {
    
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func start() {
        let vc = getViewController()

        self.viewController.present(vc, animated: false)
    }
    
    public func getViewController() -> UIViewController {
        let vc = InventoryViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
}
