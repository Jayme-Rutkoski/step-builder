//
//  InventoryCollectionViewCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//

import Foundation
import UIKit

class InventoryCollectionViewCell: GridCell {
    
    private let imageHeight: CGFloat = 50
    private let quantityHeight: CGFloat = 20
    
    private lazy var viewContainer: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    private lazy var viewQuantity: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = self.quantityHeight / 2
        view.backgroundColor = .black
        
        return view
    }()
    
    private lazy var labelQuantity: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 10)
        label.textAlignment = .center
        label.textColor = .white
        
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
            make.top.equalTo(self.contentView.snp.top)//.offset(5)
            make.left.equalTo(self.contentView.snp.left)//.offset(5)
            make.right.equalTo(self.contentView.snp.right)//.offset(-5)
            make.bottom.equalTo(self.contentView.snp.bottom)//.offset(-5)
            make.height.equalTo(self.imageHeight)
            make.width.equalTo(self.imageHeight)
        }
        
        self.imageView.addSubview(self.viewQuantity)
        self.viewQuantity.snp.makeConstraints { make in
            make.height.equalTo(self.quantityHeight)
            make.width.equalTo(self.quantityHeight)
            make.right.equalTo(self.imageView.snp.right).offset(-3)
            make.bottom.equalTo(self.imageView.snp.bottom).offset(-3)
        }
        
        self.viewQuantity.addSubview(self.labelQuantity)
        self.labelQuantity.snp.makeConstraints { make in
            make.top.equalTo(self.viewQuantity.snp.top)
            make.left.equalTo(self.viewQuantity.snp.left)
            make.right.equalTo(self.viewQuantity.snp.right)
            make.bottom.equalTo(self.viewQuantity.snp.bottom)
        }
    }
    
    func configure(with itemNumber: Int, quantity: Int, indexPath: IndexPath, columns: Int, totalItems: Int) {
        super.configure(indexPath: indexPath, columns: columns, totalItems: totalItems)
        self.imageView.image = UIImage(named: "\(itemNumber)")
        self.viewQuantity.isHidden = quantity <= 1
        self.labelQuantity.text = "\(quantity)"
    }
}
