//
//  DailyRewardView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/4/25.
//

import UIKit
import SnapKit
import Foundation

class DailyRewardView: UIView {
    
    private var onCompletion: (() -> ())!
    
    private lazy var viewOpacity: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0.6
        
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getArialBlackFont(size: 20)
        label.text = "DAILY GIFT"
        label.textColor = .white
        
        return label
    }()
    
    private lazy var viewTitle: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x800080)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private lazy var viewBackground: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0xcc99cc)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var stackViewReward: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.backgroundColor = UIColor(hex: 0xa64ca6)
        stackView.layer.cornerRadius = 15
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var buttonClaim: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Claim", for: .normal)
        button.titleLabel?.font = FontHelper.getBoldFont(size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.buttonClaim_TouchUpInside), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: 0x008000)
        button.layer.cornerRadius = 10
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    private lazy var imageViewReward: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "coin")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var labelRewardAmount: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                    .strokeColor : UIColor.black, // Color of the outline
                    .foregroundColor : UIColor.white, // Color of the text fill
                    .strokeWidth : -5.0, // Negative value for stroke to apply inside and outside the text
                    .font : FontHelper.getSFCompactRoundedBoldFont(size: 20)
                ]

        // Create an attributed string with the defined attributes
        let outlinedText = NSAttributedString(string: "25", attributes: strokeTextAttributes)

        // Assign the attributed string to the UILabel
        label.attributedText = outlinedText
        
        return label
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
            make.centerY.equalTo(self.viewBackground.snp.top)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.left.equalTo(self.viewBackground.snp.left).offset(30)
            make.right.equalTo(self.viewBackground.snp.right).offset(-30)
        }
        
        self.viewTitle.addSubview(self.labelTitle)
        self.labelTitle.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.top).offset(5)
            make.bottom.equalTo(self.viewTitle.snp.bottom).offset(-5)
            make.left.equalTo(self.viewTitle.snp.left).offset(12)
            make.right.equalTo(self.viewTitle.snp.right).offset(-12)
        }

        self.viewBackground.addSubview(self.buttonClaim)
        self.buttonClaim.snp.makeConstraints { make in
            make.centerY.equalTo(self.viewBackground.snp.bottom)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.height.equalTo(35)
            make.width.equalTo(70)
        }
        
        self.viewBackground.addSubview(self.stackViewReward)
        self.stackViewReward.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.bottom).offset(20)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.bottom.equalTo(self.buttonClaim.snp.top).offset(-25)
            make.width.equalTo(self.stackViewReward.snp.height)
        }
        
        self.stackViewReward.addArrangedSubview(self.imageViewReward)
        self.imageViewReward.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        self.viewBackground.addSubview(self.labelRewardAmount)
        self.labelRewardAmount.snp.makeConstraints { make in
            make.centerY.equalTo(self.stackViewReward.snp.bottom)
            make.centerX.equalTo(self.stackViewReward.snp.centerX)
        }
    }
    
    private func displayOnViewController(_ viewController: UIViewController) {
        viewController.view.addSubview(self)
        self.setup(viewController: viewController)
        viewController.view.layoutIfNeeded()
        viewController.view.bringSubviewToFront(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 1.0
        })
    }
    
    @objc private func buttonClaim_TouchUpInside() {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 0.0
        }) { _ in
            self.removeFromSuperview()
            self.onCompletion()
        }
        NotificationCenter.default.post(name: .CurrencyUpdate, object: 25)
    }
    
    public func displayView(_ viewController: UIViewController, onCompletion: @escaping (() -> ())) {
        self.layer.opacity = 0.0
        self.onCompletion = onCompletion
        self.displayOnViewController(viewController)
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
