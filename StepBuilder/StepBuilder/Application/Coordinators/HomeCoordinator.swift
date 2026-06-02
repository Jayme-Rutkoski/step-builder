//
//  HomeCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//

import Foundation
import UIKit

class HomeCoordinator {
    
    private var viewController: UIViewController
    private var subVC: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func start() {
        let vc = getViewController()

        self.viewController.show(vc, sender: nil)
    }
    
    public func getViewController() -> UIViewController {
        let vc = HomeViewController()
        vc.setScene()
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: CurrencyView(frame: .zero))
        if #available(iOS 26.0, *) {
            vc.navigationItem.rightBarButtonItem?.hidesSharedBackground = true
        }
            
        
        return vc
    }
    
    
}
