//
//  CircularProgressGraphView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/29/25.
//
import UIKit

class CircularProgressGraphView: UIView {

    // MARK: - Properties

    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let progressLabel = UILabel()
    private var customView = UIView()

    // Public property to set the progress (0.0 to 1.0)
    var progress: CGFloat = 0.0 {
        didSet {
            // Ensure progress is clamped between 0 and 1
            let clampedProgress = max(0.0, min(1.0, progress))
            // Update the progress bar visually
            updateProgress(clampedProgress)
            // Update the label text
            progressLabel.text = "\(Int(clampedProgress * 100))%"
        }
    }

    // Customizable properties
    var trackColor: UIColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0) { // #e0e0e0
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    var progressColor: UIColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0) { // #4CAF50
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    var lineWidth: CGFloat = 15.0 {
        didSet {
            trackLayer.lineWidth = lineWidth
            progressLayer.lineWidth = lineWidth
            // Update the path to account for new line width if needed (re-layout)
            setNeedsLayout()
        }
    }

    var labelFont: UIFont = FontHelper.getBoldFont(size: 40) {
        didSet {
            progressLabel.font = labelFont
            // Re-layout label if font size changes
            setNeedsLayout()
        }
    }

    var labelTextColor: UIColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.0) { // #333333
        didSet {
            progressLabel.textColor = labelTextColor
        }
    }

    // MARK: - Initialization

    init(customView: UIView) {
        super.init(frame: .zero)
        setupLayers()
        setupView(view: customView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        setupLabel()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        // Define the center and radius for the circles
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        // Calculate radius based on the smallest dimension and line width
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2

        // Create the circular path
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2, // Start from the top (12 o'clock)
            endAngle: 3 * CGFloat.pi / 2, // End at the top, completing a full circle
            clockwise: true
        )

        // Apply the path to both track and progress layers
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath

        // Update the label's frame to be centered
        progressLabel.sizeToFit() // Adjust label size to fit its content
        customView.center = center // Center the label
    }

    // MARK: - Setup Methods

    private func setupLayers() {
        // Configure the track layer (background circle)
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor // Important for a ring
        trackLayer.lineCap = .round // Rounded ends for the track (optional, but good for consistency)
        layer.addSublayer(trackLayer) // Add to the view's layer

        // Configure the progress layer
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor // Important for a ring
        progressLayer.lineCap = .round // Rounded ends for the progress
        // Set initial strokeEnd to 0 for no progress
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer) // Add to the view's layer
    }

    private func setupLabel() {
        progressLabel.textAlignment = .center
        progressLabel.font = labelFont
        progressLabel.textColor = labelTextColor
        self.customView = progressLabel
        setupView(view: progressLabel)
    }
    private func setupView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout for positioning
        addSubview(view)

        // Center the label using Auto Layout constraints
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Progress Update Method

    private func updateProgress(_ newProgress: CGFloat) {
        // Create a basic animation for strokeEnd
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd // Start from current progress
        animation.toValue = newProgress // Animate to the new progress
        animation.duration = 0.5 // Animation duration in seconds
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) // Smooth animation

        // Apply the animation
        progressLayer.strokeEnd = newProgress // Update the model layer immediately
        progressLayer.add(animation, forKey: "animateProgress") // Add the animation
    }
}
