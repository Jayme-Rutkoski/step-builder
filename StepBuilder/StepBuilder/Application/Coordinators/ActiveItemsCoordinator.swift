//
//  ActiveItemsCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 10/27/25.
//

import Foundation
import UIKit

class ActiveItemsCoordinator {
    
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func start() {
        let vc = getViewController()

        self.viewController.present(vc, animated: false)
    }
    
    public func getViewController() -> UIViewController {
        let vc = ActiveItemsViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
}
