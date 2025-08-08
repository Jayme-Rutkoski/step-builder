//
//  TabBarCoordinator.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//

import Foundation
import UIKit

final public class TabBarCoordinator {
    
    private var tabBarDelegate: UITabBarControllerDelegate?
    
    init() {
        let delegate = TabBarControllerDelegate()
        delegate.coordinator = self
        tabBarDelegate = delegate
    }
    
    public func start() {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self.tabBarDelegate

        let homeNC = UINavigationController(rootViewController: HomeCoordinator(viewController: tabBarController).getViewController())

        homeNC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home_unselected")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "home_selected")?.withRenderingMode(.alwaysTemplate))
        
        let awardsNC = UINavigationController(rootViewController: AwardsCoordinator(viewController: tabBarController).getViewController())

        awardsNC.tabBarItem = UITabBarItem(title: "Awards", image: UIImage(named: "awards_unselected")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "awards_selected")?.withRenderingMode(.alwaysTemplate))

        tabBarController.viewControllers = [
            homeNC,
            awardsNC
        ]
        
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .white
        
        let normalColor: UIColor = .white
        let selectedColor: UIColor = .white
        let normalTextAttributes: [NSAttributedString.Key : Any] = [.font: FontHelper.getFont(size: 12), NSAttributedString.Key.foregroundColor: normalColor]
        let selectedTextAttributes: [NSAttributedString.Key : Any] = [.font: FontHelper.getFont(size: 12), NSAttributedString.Key.foregroundColor: selectedColor]
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .black
        
        // Stacked Layout Appearance
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = normalColor
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalTextAttributes

        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes
        
        // Inline Layout Appearance
        tabBarAppearance.inlineLayoutAppearance.normal.iconColor = normalColor
        tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        
        tabBarAppearance.inlineLayoutAppearance.selected.iconColor = selectedColor
        tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes

        // Compact Inline Layout Appearance
        tabBarAppearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
        tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        
        tabBarAppearance.compactInlineLayoutAppearance.selected.iconColor = selectedColor
        tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes
        
        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        RootViewController.shared.update(to: tabBarController)
    }
    
    public func switchTab(_ viewController: UIViewController, index: Int) {
        var tabBarController: UITabBarController
        if let viewController = viewController.tabBarController {
            tabBarController = viewController
        } else if let viewController = viewController as? UITabBarController {
            tabBarController = viewController
        } else {
            return
        }
        guard let nc = tabBarController.viewControllers?[index] as? UINavigationController else { return }
        
        tabBarController.selectedIndex = index
        nc.popToRootViewController(animated: false)
    }
    
    public func navigationControllerForTab(_ index: Int) -> UINavigationController? {
        guard let tabBarController = RootViewController.shared.root as? UITabBarController else { return nil }
        return tabBarController.viewControllers?[index] as? UINavigationController
    }
    
    private func getPlaceHolderNC() -> UINavigationController {
        let placeholderNC = UINavigationController(rootViewController: UIViewController())
        placeholderNC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "")?.withRenderingMode(.alwaysTemplate))
        return placeholderNC
    }
}

public class TabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    
    public var coordinator: TabBarCoordinator?
    
    deinit {
        print("DEINIT")
    }
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let controller = tabBarController.viewControllers?.first(where: { $0 == viewController }) as? UINavigationController {
            if (controller.tabBarItem?.title ==  "") {
                return false
            }
        }
        return true
    }
}
