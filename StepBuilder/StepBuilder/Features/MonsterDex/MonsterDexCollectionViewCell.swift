//
//  MonsterDexCollectionViewCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/12/25.
//

import Foundation
import UIKit

class MonsterDexCollectionViewCell: UICollectionViewCell {
    
    
    private var viewCard: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(hex: 0x90D5FF)
        view.layer.borderColor = UIColor(hex: 0x225c7f).cgColor
        view.layer.borderWidth = 2.0
        
        return view
    }()
    
    private var viewCircle: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x2B3F4C)
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private var imageViewFound: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "emblem")
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var labelName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .black
        label.font = FontHelper.getBoldFont(size: 16)
        label.numberOfLines = 0
        
        return label
    }()

    private var labelIndex: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .black
        label.font = FontHelper.getFont(size: 16)
        label.numberOfLines = 0
        
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
        
        self.viewCard.addSubview(self.viewCircle)
        self.viewCircle.snp.makeConstraints { make in
            make.left.equalTo(self.viewCard.snp.left).offset(10)
            make.centerY.equalTo(self.viewCard.snp.centerY)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        self.viewCircle.addSubview(self.imageViewFound)
        self.imageViewFound.snp.makeConstraints { make in
            make.center.equalTo(self.viewCircle.snp.center)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        self.viewCard.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.equalTo(self.viewCard.snp.top).offset(10)
            make.left.equalTo(self.viewCircle.snp.right).offset(15)
            make.bottom.equalTo(self.viewCard.snp.bottom).offset(-10)
            make.width.equalTo(self.imageView.snp.height)
        }
        
        self.viewCard.addSubview(self.labelIndex)
        self.labelIndex.snp.makeConstraints { make in
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.centerY.equalTo(self.viewCard.snp.centerY)
        }

        self.viewCard.addSubview(self.labelName)
        self.labelName.snp.makeConstraints { make in
            make.left.equalTo(self.labelIndex.snp.right).offset(20)
            make.right.equalTo(self.viewCard.snp.right).offset(-10)
            make.centerY.equalTo(self.viewCard.snp.centerY)
        }
    }
    
    func configure(with id: Int, name: String, rarity: Int, hasSeen: Bool, indexNum: Int) {
        self.labelName.text = name
        self.imageView.image = UIImage(named: "\(id)")
        self.imageViewFound.isHidden = !hasSeen
        var indexText = "\(indexNum)"
        if (indexNum < 10) {
            indexText = "00\(indexNum)"
        } else if (indexNum < 100) {
            indexText = "0\(indexNum)"
        }
        self.labelIndex.text = "No. \(indexText)"
    }
}
