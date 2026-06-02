//
//  MonsterStorageCollectionViewCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 4/1/2026.
//

import Foundation
import UIKit

class MonsterStorageCollectionViewCell: UICollectionViewCell {
    
    private var cardHeight: CGFloat = 70.0
    private lazy var viewCard: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = cardHeight * 0.15
        view.backgroundColor = UIColor(hex: 0x90D5FF)
        view.layer.borderColor = UIColor(hex: 0x225c7f).cgColor
        view.layer.borderWidth = 1.0
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }

    
    func setup() {
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.viewCard)
        self.viewCard.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-5)
        }
        
        self.viewCard.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.equalTo(self.viewCard.snp.top).offset(5)
            make.bottom.equalTo(self.viewCard.snp.bottom).offset(-5)
            make.left.equalTo(self.viewCard.snp.left).offset(5)
            make.right.equalTo(self.viewCard.snp.right).offset(-5)
        }
    }
    
    func configure(with id: Int, currentLevel: Int) {
        self.imageView.image = UIImage(named: "\(id)")
        let starsView = createStars(rank: LevelHelper.rank(forLevel: currentLevel).rawValue)
        self.viewCard.addSubview(starsView)
        starsView.snp.makeConstraints { make in
            make.top.equalTo(self.viewCard.snp.top).offset(3)
            make.centerX.equalTo(self.viewCard.snp.centerX)
        }
    }
    
    private func createStars(rank: Int) -> UIView {
        let cardRatio = 0.30
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = -((cardHeight * cardRatio)/2)
        
        for _ in 0..<rank {
            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(named: "star_\(rank)")?.withRenderingMode(.alwaysOriginal)
            imageView.contentMode = .scaleAspectFit
            imageView.snp.makeConstraints { make in
                make.height.equalTo(cardHeight * cardRatio)
                make.width.equalTo(cardHeight * cardRatio)
            }
            stackView.addArrangedSubview(imageView)
        }
        
        return stackView
    }
}
