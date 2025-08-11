//
//  ShopBuyView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/8/25.
//

import UIKit
import SnapKit
import Foundation

class ShopBuyView: UIView {
    
    private var onCompletion: (() -> ())!
    private var price: Int = 0
    private var viewController: UIViewController!
    
    private lazy var buttonClose: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonClose_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var viewOpacity: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0.8
        
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getArialBlackFont(size: 20)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var viewTitle: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x99cc99)
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        
        return view
    }()
    
    private lazy var viewBackground: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x99cccc)
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private lazy var stackViewItem: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.backgroundColor = UIColor(hex: 0x99cc99)
        stackView.layer.cornerRadius = 20
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.borderWidth = 1.5
        
        return stackView
    }()
    
    private lazy var buttonBuy: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = FontHelper.getBoldFont(size: 16)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(buttonBuy_TouchUpInside), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: 0x99cc99)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.5
        button.isUserInteractionEnabled = true
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 17, bottom: 6, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        
        return button
    }()
    
    private lazy var imageViewItem: UIImageView = {
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
        
        self.viewBackground.addSubview(self.buttonClose)
        self.buttonClose.snp.makeConstraints { make in
            make.top.equalTo(self.viewBackground.snp.top).offset(10)
            make.right.equalTo(self.viewBackground.snp.right).offset(-10)
            make.height.equalTo(25)
            make.width.equalTo(25)
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

        self.viewBackground.addSubview(self.buttonBuy)
        self.buttonBuy.snp.makeConstraints { make in
            make.bottom.equalTo(self.viewBackground.snp.bottom).offset(-20)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        self.viewBackground.addSubview(self.stackViewItem)
        self.stackViewItem.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.bottom).offset(20)
            make.left.equalTo(self.viewBackground.snp.left).offset(40)
            make.right.equalTo(self.viewBackground.snp.right).offset(-40)
            make.bottom.equalTo(self.buttonBuy.snp.top).offset(-20)
            make.width.equalTo(self.stackViewItem.snp.height)
        }
        
        self.stackViewItem.addArrangedSubview(self.imageViewItem)
        self.imageViewItem.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
    }
    
    private func displayOnViewController(_ viewController: UIViewController, itemNumber: Int, name: String, price: Int) {
        self.price = price
        self.imageViewItem.image = UIImage(named: "\(itemNumber)")
        self.labelTitle.text = name
        self.buttonBuy.setTitle("\(price)", for: .normal)
        self.buttonBuy.setImage(UIImage(named: "coin"), for: .normal)
        viewController.view.addSubview(self)
        self.setup(viewController: viewController)
        viewController.view.layoutIfNeeded()
        viewController.view.bringSubviewToFront(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 1.0
        })
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 0.0
        }) { _ in
            self.removeFromSuperview()
            self.onCompletion()
        }
    }
    
    @objc private func buttonClose_TouchUpInside() {
        self.dismiss()
    }
    
    @objc private func buttonBuy_TouchUpInside() {
        if (SwiftAppDefaults.shared.coins < self.price) {
            let alertVC = UIAlertController(title: "Not enough coins.", message: "You need \(self.price - SwiftAppDefaults.shared.coins) more coins.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.viewController.dismiss(animated: true)
                self.dismiss()
            }))
            
            self.viewController.present(alertVC, animated: true)
        } else {
            let alertVC = UIAlertController(title: "Are you sure?", message: "Do you want to confirm your purchase?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.viewController.dismiss(animated: true)
                NotificationCenter.default.post(name: .CurrencyUpdate, object: -5)
                self.dismiss()
            }))
            alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
                self.viewController.dismiss(animated: true)
            }))
            
            self.viewController.present(alertVC, animated: true)
        }
    }
    
    public func displayView(_ viewController: UIViewController, itemNumber: Int, name: String, price: Int, onCompletion: @escaping (() -> ())) {
        self.layer.opacity = 0.0
        self.viewController = viewController
        self.onCompletion = onCompletion
        self.displayOnViewController(viewController, itemNumber: itemNumber, name: name, price: price)
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
