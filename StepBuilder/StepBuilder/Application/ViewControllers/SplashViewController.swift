//
//  SplashViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//


import Foundation
import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    private lazy var imageViewLogo: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "appicon")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: 0x1D1A1A)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    func setup() {
        self.view.addSubview(self.imageViewLogo)
        self.imageViewLogo.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        self.startAnimation()
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat, .autoreverse]) {
            self.imageViewLogo.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
}
