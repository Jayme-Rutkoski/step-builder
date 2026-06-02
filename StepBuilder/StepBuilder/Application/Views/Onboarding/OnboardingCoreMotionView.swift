//
//  OnboardingCoreMotionView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 6/1/2026.
//

import UIKit
import SnapKit

class OnboardingCoreMotionView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "onboarding_core_motion"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Track your steps"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "StepBuilder uses Motion & Fitness to count your steps and help you discover monsters while you walk."
        label.font = .systemFont(ofSize: 17)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
    }
    
}
