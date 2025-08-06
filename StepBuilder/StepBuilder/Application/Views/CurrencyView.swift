//
//  CurrencyView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/4/25.
//
import UIKit
import SnapKit
import Foundation
import UICountingLabel

class CurrencyView: UIView {
    
    private lazy var labelCurrency: UICountingLabel = {
        let label = UICountingLabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 16)
        label.count(from: 0, to: CGFloat(SwiftAppDefaults.shared.coins), withDuration: 0.3)
        label.textColor = .black
        label.format = "%d"
        
        return label
    }()
    
    private lazy var imageViewCoin: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "coin")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        return stackView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(dailyRewardClaimed), name: .DailyRewardClaimed, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.stackView.addArrangedSubview(self.imageViewCoin)
        self.imageViewCoin.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        self.stackView.addArrangedSubview(self.labelCurrency)
            
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    @objc private func dailyRewardClaimed(_ notification: Notification) {
        let dailyReward = notification.object as? Int ?? 0
        var newCoins = SwiftAppDefaults.shared.coins
        let oldCoins = newCoins
        newCoins = newCoins + dailyReward
        SwiftAppDefaults.shared.coins = newCoins
        self.labelCurrency.count(from: CGFloat(oldCoins), to: CGFloat(newCoins), withDuration: 0.3)
    }
}
