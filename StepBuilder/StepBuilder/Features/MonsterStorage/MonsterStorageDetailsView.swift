//
//  MonsterStorageDetailsView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 6/1/2026.
//

import UIKit
import SnapKit
import Foundation

class MonsterStorageDetailsView: UIView {
    
    private var onCompletion: (() -> ())!
    private var monster: Monster = Monster()
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonClose_TouchUpInside)))
        
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getArialBlackFont(size: 20)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.tintColor = UIColor(hex: 0x800080)
        progressView.trackTintColor = UIColor(hex: 0xcc99cc)
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        
        return progressView
    }()
    
    private var labelProgress: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .black
        label.font = FontHelper.getBoldFont(size: 14)
        
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
    
    private lazy var imageViewMonster: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var imageViewRarity: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: 0x800080)
        
        return imageView
    }()
    
    private lazy var stackViewMonster: UIStackView = {
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
    
    private lazy var buttonUpgrade: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        configuration.baseBackgroundColor = UIColor(hex: 0x99cc99)
        configuration.baseForegroundColor = .black
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = FontHelper.getBoldFont(size: 16)
            return outgoing
        }
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(buttonUpgrade_TouchUpInside), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.5
        button.isUserInteractionEnabled = true
        button.semanticContentAttribute = .forceRightToLeft
        
        return button
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
        
        self.viewBackground.addSubview(self.buttonUpgrade)
        self.buttonUpgrade.snp.makeConstraints { make in
            make.bottom.equalTo(self.viewBackground.snp.bottom).offset(-20)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.height.equalTo(40)
            //make.width.equalTo(100)
        }
        
        self.viewBackground.addSubview(self.labelProgress)
        self.labelProgress.snp.makeConstraints { make in
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.bottom.equalTo(self.buttonUpgrade.snp.top).offset(-10)
        }
        
        self.viewBackground.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { make in
            make.left.equalTo(self.viewBackground.snp.left).offset(40)
            make.right.equalTo(self.viewBackground.snp.right).offset(-40)
            make.bottom.equalTo(self.labelProgress.snp.top).offset(-5)
            make.height.equalTo(10)
        }
        
        self.viewBackground.addSubview(self.stackViewMonster)
        self.stackViewMonster.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.bottom).offset(20)
            make.left.equalTo(self.viewBackground.snp.left).offset(40)
            make.right.equalTo(self.viewBackground.snp.right).offset(-40)
            make.bottom.equalTo(self.progressView.snp.top).offset(-20)
            make.width.equalTo(self.stackViewMonster.snp.height)
        }
        
        self.stackViewMonster.addArrangedSubview(self.imageViewMonster)
        self.imageViewMonster.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        self.imageViewMonster.addSubview(self.imageViewRarity)
        self.imageViewRarity.snp.makeConstraints { make in
            make.top.equalTo(self.imageViewMonster.snp.top).offset(5)
            make.right.equalTo(self.imageViewMonster.snp.right).offset(-5)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
    }
    
    private func displayOnViewController(_ viewController: UIViewController, monster: Monster) {
        self.monster = monster
        self.imageViewMonster.image = UIImage(named: "\(monster.id)")
        self.updateProgress()
        self.setRarityImage()
        
        viewController.view.addSubview(self)
        self.setup(viewController: viewController)
        viewController.view.layoutIfNeeded()
        viewController.view.bringSubviewToFront(self)

        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 1.0
        })
    }
    
    private func setRarityImage() {
        var imageName = ""
        switch monster.rarity {
        case .legendary:
            imageName = "crown.fill"
        case .rare:
            imageName = "star.fill"
        case .uncommon:
            imageName = "diamond.fill"
        default:
            imageName = "circle.fill"
        }
        
        self.imageViewRarity.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    private func updateProgress() {
        self.labelTitle.text = "\(monster.name) (Lv. \(monster.currentLevel ?? 1))"
        self.buttonUpgrade.configuration?.title = "Upgrade to Level \((self.monster.currentLevel ?? 1) + 1)"
        let currentShards = MonsterHelper.getAllMonsterInventoryIDsByID(monster.id).count
        let targetShards = LevelHelper.shardsRequiredForNextLevel(fromCurrentLevel: monster.currentLevel ?? 1, rarity: monster.rarity)
        self.labelProgress.text = "\(currentShards) / \(targetShards)"
        self.progressView.progress = Float(CGFloat(CGFloat(currentShards) / CGFloat(targetShards)))
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 0.0
        }) { _ in
            self.removeFromSuperview()
            self.onCompletion()
        }
    }
    
    @objc private func buttonUpgrade_TouchUpInside() {
        let currentShards = MonsterHelper.getAllMonsterInventoryIDsByID(monster.id).count
        let targetShards = LevelHelper.shardsRequiredForNextLevel(fromCurrentLevel: monster.currentLevel ?? 1, rarity: monster.rarity)
        
        if (currentShards < targetShards) {
            let alertVC = UIAlertController(title: "Not enough to level up", message: "You need \(targetShards - currentShards) more!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.viewController.dismiss(animated: true)
            }))
            
            self.viewController.present(alertVC, animated: true)
        } else {
            MonsterHelper.removeMonsterInventoryIDsByIDAndAmount(monster.id, amount: targetShards)
            monster.currentLevel = (monster.currentLevel ?? 1) + 1
            MonsterCollectionHelper.saveMonster(monster)
            
            self.updateProgress()
            
            let alertVC = UIAlertController(title: "Congratulations!!", message: "Leveled up to Level \(monster.currentLevel ?? 1)!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.viewController.dismiss(animated: true)
            }))
            self.viewController.present(alertVC, animated: true)
        }
    }
    
    @objc private func buttonClose_TouchUpInside() {
        self.dismiss()
    }
    
    public func displayView(_ viewController: UIViewController, monster: Monster, onCompletion: @escaping (() -> ())) {
        self.layer.opacity = 0.0
        self.viewController = viewController
        self.onCompletion = onCompletion
        self.displayOnViewController(viewController, monster: monster)
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
