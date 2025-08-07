//
//  MonsterFoundView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/6/25.
//

import UIKit
import SnapKit
import Foundation

class MonsterFoundView: UIView {
    
    private var onCompletion: (() -> ())!
    
    private lazy var viewOpacity: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0.8
        
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getArialBlackFont(size: 20)
        label.text = "Monster Found!"
        label.textColor = .white
        
        return label
    }()
    
    private lazy var viewTitle: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x800080)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var viewBackground: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0xcc99cc)
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private lazy var stackViewMonster: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.backgroundColor = UIColor(hex: 0xa64ca6)
        stackView.layer.cornerRadius = 20
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var buttonClose: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = FontHelper.getBoldFont(size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonClose_TouchUpInside), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: 0x800080)
        button.layer.cornerRadius = 10
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    private lazy var imageViewMonster: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private func setup(viewController: UIViewController) {
        self.addSubview(self.viewOpacity)
        self.viewOpacity.snp.makeConstraints { make in
            make.edges.equalTo(viewController.view.snp.edges)
        }
        
        self.addSubview(self.viewBackground)
        self.viewBackground.snp.makeConstraints { make in
            make.centerX.equalTo(viewController.view.snp.centerX)
            make.centerY.equalTo(viewController.view.snp.centerY)
            make.height.equalTo(0).priority(250)
        }
        
        self.addSubview(self.viewTitle)
        self.viewTitle.snp.makeConstraints { make in
            make.top.equalTo(self.viewBackground.snp.top).offset(20)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
        }
        
        self.viewTitle.addSubview(self.labelTitle)
        self.labelTitle.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.top).offset(5)
            make.bottom.equalTo(self.viewTitle.snp.bottom).offset(-5)
            make.left.equalTo(self.viewTitle.snp.left).offset(12)
            make.right.equalTo(self.viewTitle.snp.right).offset(-12)
        }

        self.viewBackground.addSubview(self.buttonClose)
        self.buttonClose.snp.makeConstraints { make in
            make.bottom.equalTo(self.viewBackground.snp.bottom).offset(-20)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(70)
        }
        
        self.viewBackground.addSubview(self.stackViewMonster)
        self.stackViewMonster.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.bottom).offset(20)
            make.left.equalTo(self.viewBackground.snp.left).offset(40)
            make.right.equalTo(self.viewBackground.snp.right).offset(-40)
            make.bottom.equalTo(self.buttonClose.snp.top).offset(-20)
            make.width.equalTo(self.stackViewMonster.snp.height)
        }
        
        self.stackViewMonster.addArrangedSubview(self.imageViewMonster)
        self.imageViewMonster.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }
    
    private func displayOnViewController(_ viewController: UIViewController, monsterNumber: Int = 99999) {
        self.imageViewMonster.image = UIImage(named: "\(monsterNumber)")
        viewController.view.addSubview(self)
        self.setup(viewController: viewController)
        viewController.view.layoutIfNeeded()
        viewController.view.bringSubviewToFront(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 1.0
        })
    }
    
    @objc private func buttonClose_TouchUpInside() {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 0.0
        }) { _ in
            self.removeFromSuperview()
            self.onCompletion()
        }
    }
    
    public func displayView(_ viewController: UIViewController, monsterNumber: Int = 99999, onCompletion: @escaping (() -> ())) {
        self.layer.opacity = 0.0
        self.onCompletion = onCompletion
        self.displayOnViewController(viewController, monsterNumber: monsterNumber)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
