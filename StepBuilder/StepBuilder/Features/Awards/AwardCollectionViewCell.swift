//
//  AwardCollectionViewCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/7/25.
//

import Foundation
import UIKit

class AwardCollectionViewCell: UICollectionViewCell {
    
    private let imageHeight: CGFloat = 90
    
    private lazy var viewContainer: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.imageHeight / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        
        return imageView
    }()
    
    private lazy var viewNotCompleted: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0.6
        view.isHidden = true
        view.layer.cornerRadius = self.imageHeight / 2
        
        return view
    }()
    
    private var labelName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .black
        label.font = FontHelper.getBoldFont(size: 12)
        
        return label
    }()
    
    private var viewCompletionTimes: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 7
        
        return view
    }()
    
    private var labelCompletionTimes: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.font = FontHelper.getBoldFont(size: 10)
        
        return label
    }()
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.tintColor = UIColor(hex: 0x800080)
        progressView.trackTintColor = UIColor(hex: 0xcc99cc)
        progressView.layer.cornerRadius = 3
        progressView.isHidden = true
        progressView.clipsToBounds = true
        
        return progressView
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
        self.viewNotCompleted.isHidden = true
        self.progressView.isHidden = true
        self.viewCompletionTimes.isHidden = true
    }

    
    func setup() {
        self.contentView.addSubview(self.viewContainer)
        self.viewContainer.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        
        self.viewContainer.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.equalTo(self.viewContainer.snp.top)
            make.width.equalTo(self.imageHeight)
            make.height.equalTo(self.imageHeight)
            make.centerX.equalTo(self.viewContainer.snp.centerX)
        }
        self.imageView.addSubview(self.viewNotCompleted)
        self.viewNotCompleted.snp.makeConstraints { make in
            make.edges.equalTo(self.imageView)
        }
        
        self.viewContainer.addSubview(self.labelName)
        self.labelName.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(4)
            make.left.equalTo(self.viewContainer.snp.left)
            make.right.equalTo(self.viewContainer.snp.right)
            make.centerX.equalTo(self.imageView.snp.centerX)
        }
        
        self.viewContainer.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { make in
            make.top.equalTo(self.labelName.snp.bottom).offset(4)
            make.left.equalTo(self.imageView.snp.left)
            make.right.equalTo(self.imageView.snp.right)
            make.centerX.equalTo(self.imageView.snp.centerX)
            make.height.equalTo(6)
        }
        
        self.viewContainer.addSubview(self.viewCompletionTimes)
        self.viewCompletionTimes.snp.makeConstraints { make in
            make.top.equalTo(self.labelName.snp.bottom).offset(4)
            make.left.equalTo(self.imageView.snp.left)
            make.right.equalTo(self.imageView.snp.right)
            make.centerX.equalTo(self.imageView.snp.centerX)
            make.height.equalTo(14)
        }
        
        self.viewCompletionTimes.addSubview(self.labelCompletionTimes)
        self.labelCompletionTimes.snp.makeConstraints { make in
            make.edges.equalTo(self.viewCompletionTimes).inset(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
    }
    
    func configure(with name: String, image: UIImage?, completionTimes: Int?, progress: CGFloat?, isCompleted: Bool) {
        self.labelName.text = name
        self.imageView.image = image
        self.viewNotCompleted.isHidden = isCompleted
        
        if let completionTimes = completionTimes {
            self.viewCompletionTimes.isHidden = !isCompleted
            self.progressView.isHidden = true
            self.labelCompletionTimes.text = "\(completionTimes.withCommas())"
        } else if let progress = progress {
            self.progressView.isHidden = isCompleted || progress == 0.0 || progress == 1.0
            self.viewCompletionTimes.isHidden = true
            self.progressView.progress = Float(progress)
        }
    }
}
