//
//  ShopCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/8/25.
//

import Foundation
import UIKit

class ShopCoordinator {
    
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func start() {
        let vc = getViewController()

        self.viewController.show(vc, sender: nil)
    }
    
    public func getViewController() -> UIViewController {
        let vc = ShopViewController()
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: CurrencyView(frame: .zero))
        if #available(iOS 26.0, *) {
            vc.navigationItem.rightBarButtonItem?.hidesSharedBackground = true
        }
        
        return vc
    }
}
