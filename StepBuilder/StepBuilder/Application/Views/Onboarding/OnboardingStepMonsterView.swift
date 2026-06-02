//
//  OnboardingStepMonsterView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 6/1/2026.
//

import UIKit

class OnboardingStepMonsterView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "onboarding_steps_monsters"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Walk to find monsters"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Every step helps search new tiles. The more you walk, the more chances you have to discover monsters."
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
            make.height.equalTo(240)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(28)
            make.left.right.equalToSuperview().inset(24)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(28)
            //make.bottom.equalToSuperview()
        }
    }
}
