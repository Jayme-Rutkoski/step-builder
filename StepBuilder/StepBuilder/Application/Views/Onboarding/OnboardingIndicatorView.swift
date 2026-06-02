//
//  OnboardingIndicatorView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 6/1/2026.
//
import UIKit

final class OnboardingIndicatorView: UIStackView {

    var numberOfPages: Int = 0 {
        didSet { setupDots() }
    }

    var currentPage: Int = 0 {
        didSet { updateDots() }
    }

    private var dots: [UIView] = []
    private var widthConstraints: [NSLayoutConstraint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStack()
    }

    private func setupStack() {
        axis = .horizontal
        spacing = 8
        alignment = .center
        distribution = .fill
    }

    private func setupDots() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        dots.removeAll()
        widthConstraints.removeAll()

        for _ in 0..<numberOfPages {
            let dot = UIView()
            dot.layer.cornerRadius = 4
            dot.backgroundColor = .systemGray4
            dot.clipsToBounds = true

            let width = dot.widthAnchor.constraint(equalToConstant: 8)
            let height = dot.heightAnchor.constraint(equalToConstant: 8)

            NSLayoutConstraint.activate([width, height])

            addArrangedSubview(dot)

            dots.append(dot)
            widthConstraints.append(width)
        }

        updateDots(animated: false)
    }

    private func updateDots(animated: Bool = true) {
        guard dots.indices.contains(currentPage) else { return }

        for (index, dot) in dots.enumerated() {
            let isSelected = index == currentPage

            dot.backgroundColor = isSelected ? UIColor(hex: 0x800080) : .black
            widthConstraints[index].constant = isSelected ? 18 : 8
        }

        let animations = {
            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: animations)
        } else {
            animations()
        }
    }
}
