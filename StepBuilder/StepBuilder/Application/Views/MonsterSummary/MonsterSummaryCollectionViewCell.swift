//
//  MonsterSummaryCollectionViewCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/13/25.
//

import Foundation
import UIKit

class MonsterSummaryCollectionViewCell: UICollectionViewCell {
    
    
    private var viewCard: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var labelName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = FontHelper.getBoldFont(size: 16)
        label.numberOfLines = 0
        
        return label
    }()

    private var labelQuantity: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.textColor = .white
        label.font = FontHelper.getBoldFont(size: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    
    private lazy var viewNew: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0xE50000)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var labelNew: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 12)
        label.text = "NEW"
        label.textAlignment = .center
        label.textColor = .white
        
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
            make.top.equalTo(self.viewCard.snp.top).offset(10)
            make.left.equalTo(self.viewCard.snp.left).offset(10)
            make.bottom.equalTo(self.viewCard.snp.bottom).offset(-10)
            make.width.equalTo(self.imageView.snp.height)
        }
        
        self.viewCard.addSubview(self.viewNew)
        self.viewNew.snp.makeConstraints { make in
            make.centerY.equalTo(self.imageView.snp.top).offset(3)
            make.centerX.equalTo(self.imageView.snp.right).offset(-3)
            make.height.equalTo(20)
        }
        
        self.viewNew.addSubview(self.labelNew)
        self.labelNew.snp.makeConstraints { make in
            make.top.equalTo(self.viewNew.snp.top).offset(2)
            make.left.equalTo(self.viewNew.snp.left).offset(5)
            make.right.equalTo(self.viewNew.snp.right).offset(-5)
            make.bottom.equalTo(self.viewNew.snp.bottom).offset(-2)
        }
        
        self.viewCard.addSubview(self.labelQuantity)
        self.labelQuantity.snp.makeConstraints { make in
            make.right.equalTo(self.viewCard.snp.right).offset(-10)
            make.centerY.equalTo(self.viewCard.snp.centerY)
        }
        
        self.viewCard.addSubview(self.labelName)
        self.labelName.snp.makeConstraints { make in
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.right.equalTo(self.labelQuantity.snp.right).offset(-10)
            make.centerY.equalTo(self.viewCard.snp.centerY)
        }
    }
    
    func configure(with id: Int, name: String, quantity: Int, isNew: Bool) {
        self.labelName.text = name
        self.imageView.image = UIImage(named: "\(id)")
        self.labelQuantity.text = "x\(quantity)"
        self.viewNew.isHidden = !isNew
    }
}
