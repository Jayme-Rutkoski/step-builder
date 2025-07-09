//
//  OnboardingViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//


import Foundation
import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    private var buttonNextHeight: CGFloat = 55
    private var completion: (() -> ())?
    
    private lazy var buttonNext: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = self.buttonNextHeight / 2
        button.addTarget(self, action: #selector(buttonNext_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(completion: @escaping (() -> ())) {
        super.init(nibName: nil, bundle: nil)
        
        self.completion = completion
    }
    
    func setup() {
        
        self.view.addSubview(self.buttonNext)
        self.buttonNext.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.height.equalTo(self.buttonNextHeight)
        }
    }
    
    @objc func buttonNext_TouchUpInside() {
        completion?()
    }
}
