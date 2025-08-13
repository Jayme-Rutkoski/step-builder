//
//  ShopCollectionViewCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/8/25.
//

import Foundation
import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    private let imageHeight: CGFloat = 150
    
    private lazy var viewContainer: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    private var viewCard: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hex: 0x99cc99)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var labelName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .black
        label.font = FontHelper.getBoldFont(size: 18)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var imageViewCoin: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "coin")
        
        return imageView
    }()
    
    private var labelPrice: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .black
        label.font = FontHelper.getBoldFont(size: 16)
        
        return label
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
        self.labelName.text = ""
        self.labelPrice.text = ""
    }

    
    func setup() {
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.viewContainer)
        self.viewContainer.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-5)
        }
        
        self.viewContainer.addSubview(self.viewCard)
        self.viewCard.snp.makeConstraints { make in
            make.top.equalTo(self.viewContainer.snp.top)
            make.left.equalTo(self.viewContainer.snp.left)
            make.right.equalTo(self.viewContainer.snp.right)
        }

        self.viewCard.addSubview(self.labelName)
        self.labelName.snp.makeConstraints { make in
            make.left.equalTo(self.viewCard.snp.left).offset(10)
            make.right.equalTo(self.viewCard.snp.right).offset(-10)
            make.bottom.equalTo(self.viewCard.snp.bottom).offset(-10)
        }
        
        self.viewCard.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.equalTo(self.viewCard.snp.top).offset(5)
            make.left.equalTo(self.viewCard.snp.left).offset(10)
            make.right.equalTo(self.viewCard.snp.right).offset(-10)
            make.bottom.equalTo(self.labelName.snp.top).offset(-5)
            make.height.equalTo(self.imageHeight)
        }
        
        self.viewContainer.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.viewCard.snp.bottom).offset(6)
            make.centerX.equalTo(self.viewCard.snp.centerX)
        }
        
        self.stackView.addArrangedSubview(self.labelPrice)
        self.stackView.addArrangedSubview(self.imageViewCoin)
        self.imageViewCoin.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
    }
    
    func configure(with itemNumber: Int, name: String, price: Int) {
        self.labelName.text = name
        self.imageView.image = UIImage(named: "\(itemNumber)")
        self.labelPrice.text = "\(price)"
    }
}
