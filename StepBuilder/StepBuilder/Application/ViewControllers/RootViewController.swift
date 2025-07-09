//
//  RootViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//


import UIKit
import MessageUI

public class RootViewController: UIViewController {
    
    public static let shared: RootViewController = RootViewController()
    
    public var root: UIViewController = UIViewController()
    
    private var _prefersStatusBarHidden: Bool = false
    private var _supportedInterfaceOrientations: UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial
        self.root.willMove(toParent: self)
        addChild(self.root)
        self.root.view.frame = self.view.bounds
        self.view.addSubview(self.root.view)
        self.root.didMove(toParent: self)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public override var prefersStatusBarHidden: Bool {
        return _prefersStatusBarHidden
    }
    /*
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return _preferredStatusBarStyle
    }
     */
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return _supportedInterfaceOrientations
    }
    
    
    
    // MARK: - Private API
    private func animateUpTransition(to root: UIViewController, completion: (() -> ())?) {
        
        self.root.willMove(toParent: nil)
        root.willMove(toParent: self)
        
        self.addChild(root)
        
        let startY = self.root.view.center.y + self.view.bounds.size.height
        let endY = self.root.view.center.y
        
        root.view.center = CGPoint(x: self.root.view.center.x, y: startY)
        
        transition(from: self.root, to: root, duration: 0.3, options: UIView.AnimationOptions(rawValue: 0), animations: {
            root.view.center = CGPoint(x: self.root.view.center.x, y: endY)
        }) { (completed) in
            
            self.root.removeFromParent()
            self.root.didMove(toParent: nil)
            root.didMove(toParent: self)
            
            self.root = root
            
            // TODO: Attempt
            self._prefersStatusBarHidden = root.prefersStatusBarHidden
            //self._preferredStatusBarStyle = root.preferredStatusBarStyle
            self._supportedInterfaceOrientations = root.supportedInterfaceOrientations
            
            self.animateStatusBarAppearanceUpdate()
            
            completion?()
        }
    }
    private func animateDownTransition(to root: UIViewController, completion: (() -> ())?) {
        
        let endY = self.root.view.center.y + self.view.bounds.size.height
        
        
        self.root.willMove(toParent: nil)
        root.willMove(toParent: self)
        
        self.addChild(root)
        root.view.frame = self.view.frame
        self.view.insertSubview(root.view, at: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.root.view.center = CGPoint(x: self.view.center.x, y: endY)
        }) { (completed) in
            
            self.root.view.removeFromSuperview()
            self.root.removeFromParent()
            self.root.didMove(toParent: nil)
            
            root.didMove(toParent: self)
            self.root = root
            
            // TODO: Attempt
            self._prefersStatusBarHidden = root.prefersStatusBarHidden
            //self._preferredStatusBarStyle = root.preferredStatusBarStyle
            self._supportedInterfaceOrientations = root.supportedInterfaceOrientations
            
            self.animateStatusBarAppearanceUpdate()
            
            completion?()
        }
    }
    private func animateFadeTransition(to root: UIViewController, completion: (() -> ())?) {
        
        // Current
        self.root.willMove(toParent: nil)
        
        // Root
        root.willMove(toParent: self)
        addChild(root)
        
        // Transition
        transition(from: self.root, to: root, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { (completed) in
            
            // Curent
            self.root.view.removeFromSuperview()
            self.root.removeFromParent()
            
            // Root
            root.didMove(toParent: self)
            self.root = root
            
            // TODO: Attempt
            self._prefersStatusBarHidden = root.prefersStatusBarHidden
            //self._preferredStatusBarStyle = root.preferredStatusBarStyle
            self._supportedInterfaceOrientations = root.supportedInterfaceOrientations
            
            self.animateStatusBarAppearanceUpdate()
            
            completion?()
        }
    }
    
    private func animateStatusBarAppearanceUpdate() {
        
        UIView.animate(withDuration: 0.2) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Public API
    public func up(to root: UIViewController, completion: (()->())? = nil) {
        animateUpTransition(to: root, completion: completion)
    }
    public func down(to root: UIViewController, completion: (()->())? = nil) {
        animateDownTransition(to: root, completion: completion)
    }
    public func fade(to root: UIViewController, completion: (()->())? = nil) {
        animateFadeTransition(to: root, completion: completion)
    }
    public func update(to root: UIViewController, completion: (()->())? = nil) {
        
        root.willMove(toParent: self)
        addChild(root)
        root.view.frame = view.bounds
        view.addSubview(root.view)
        root.didMove(toParent: self)
        
        self.root.willMove(toParent: nil)
        self.root.view.removeFromSuperview()
        self.root.removeFromParent()
        self.root.didMove(toParent: nil)
        
        self.root = root
        
        // TODO: Attempt
        self._prefersStatusBarHidden = root.prefersStatusBarHidden
        //self._preferredStatusBarStyle = root.preferredStatusBarStyle
        self._supportedInterfaceOrientations = root.supportedInterfaceOrientations
        
        animateStatusBarAppearanceUpdate()
                
        completion?()
    }
    
    public func updateStatusBarHidden(_ hideStatusBar: Bool) {
        _prefersStatusBarHidden = hideStatusBar
        
        UIView.animate(withDuration: 0.2) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    
}

extension RootViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
