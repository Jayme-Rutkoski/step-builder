//
//  InventoryDetailView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/12/25.
//

import UIKit
import SnapKit
import Foundation

class InventoryDetailView: UIView {
    
    private var onCompletion: (() -> ())!
    private var itemNumber: Int = 0
    private var viewController: UIViewController!
    
    private lazy var buttonClose: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = FontHelper.getBoldFont(size: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonClose_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var viewOpacity: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var labelDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getFont(size: 14)
        label.textColor = .black
        label.textAlignment = .natural
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var viewTitle: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x99cc99)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var viewBackground: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x99cccc)
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        
        return view
    }()
    
    private lazy var buttonConsume: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = FontHelper.getBoldFont(size: 16)
        button.setTitle("Consume", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonConsume_TouchUpInside), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: 0x99cc99)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.5
        button.isUserInteractionEnabled = true
        
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
        
        self.addSubview(self.viewTitle)
        self.viewTitle.snp.makeConstraints { make in
            make.top.equalTo(self.viewBackground.snp.top)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.left.equalTo(self.viewBackground.snp.left)
            make.right.equalTo(self.viewBackground.snp.right)
            make.height.greaterThanOrEqualTo(45)
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
        }
        
        self.viewBackground.addSubview(self.buttonConsume)
        self.buttonConsume.snp.makeConstraints { make in
            make.bottom.equalTo(self.buttonClose.snp.top).offset(-5)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        
        self.viewBackground.addSubview(self.labelDescription)
        self.labelDescription.snp.makeConstraints { make in
            make.left.equalTo(self.viewBackground.snp.left).offset(20)
            make.right.equalTo(self.viewBackground.snp.right).offset(-20)
            make.bottom.equalTo(self.buttonConsume.snp.top).offset(-20)
        }
        
        self.viewBackground.addSubview(self.imageViewItem)
        self.imageViewItem.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.bottom).offset(20)
            make.left.equalTo(self.viewBackground.snp.left).offset(40)
            make.right.equalTo(self.viewBackground.snp.right).offset(-40)
            make.bottom.equalTo(self.labelDescription.snp.top).offset(-20)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
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
    
    @objc private func buttonConsume_TouchUpInside() {
        let alertVC = UIAlertController(title: "Are you sure?", message: "Do you want to confirm your purchase?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            ItemHelper.consumeItem(self.itemNumber)
            self.dismiss()
        }))
        alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            
        }))
        
        self.viewController.present(alertVC, animated: true)
    }
    
    
    private func displayOnViewController(_ viewController: UIViewController, itemNumber: Int, name: String, desc: String) {
        self.itemNumber = itemNumber
        self.imageViewItem.image = UIImage(named: "\(itemNumber)")
        self.labelTitle.text = name
        self.labelDescription.text = desc
        viewController.view.addSubview(self)
        self.setup(viewController: viewController)
        viewController.view.layoutIfNeeded()
        viewController.view.bringSubviewToFront(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 1.0
        })
    }
    
    public func displayView(_ viewController: UIViewController, itemNumber: Int, name: String, desc: String, onCompletion: @escaping (() -> ())) {
        self.layer.opacity = 0.0
        self.viewController = viewController
        self.onCompletion = onCompletion
        self.displayOnViewController(viewController, itemNumber: itemNumber, name: name, desc: desc)
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
