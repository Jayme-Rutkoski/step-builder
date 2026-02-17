//
//  ActiveItemCollectionViewCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 10/27/25.
//

import Foundation
import UIKit

class ActiveItemCollectionViewCell: UICollectionViewCell {
    
    private let imageHeight: CGFloat = 30
    
    private lazy var viewContainer: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    
    private lazy var labelName: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 15)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
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
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(2)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-2)
            make.height.equalTo(self.imageHeight)
            make.width.equalTo(self.imageHeight)
        }
        
        self.contentView.addSubview(self.labelName)
        self.labelName.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top)
            make.left.equalTo(self.imageView.snp.right).offset(5)
            make.right.equalTo(self.contentView.snp.right).offset(-5)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
    }
    
    func configure(with itemNumber: Int, name: String) {
        self.imageView.image = UIImage(named: "\(itemNumber)")?.withRenderingMode(.alwaysOriginal)
        self.labelName.text = name
    }
}
