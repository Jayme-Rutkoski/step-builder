//
//  StepLineGraphView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/7/25.
//

import UIKit

/// A custom UIView subclass that draws a line graph for step data.
class StepLineGraphView: UIView {

    // MARK: - Properties

    /// The data points representing step counts.
    /// Each value in the array corresponds to a point on the Y-axis.
    /// The index of the value corresponds to the X-axis position.
    var stepData: [CGFloat] = [] {
        didSet {
            // When data changes, redraw the view.
            setNeedsDisplay()
        }
    }

    /// The color of the graph line.
    var lineColor: UIColor = .systemBlue

    /// The color of the graph fill (area under the line).
    var fillColor: UIColor = .systemBlue.withAlphaComponent(0.3)

    /// The color of the X and Y axes.
    var axisColor: UIColor = .gray

    /// The width of the graph line.
    var lineWidth: CGFloat = 2.0

    /// Padding from the edges of the view for the graph.
    var graphPadding: CGFloat = 40.0

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Set a transparent background to allow custom drawing.
        backgroundColor = .clear
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Calculate the drawing area within the padding.
        let graphWidth = rect.width - (2 * graphPadding)
        let graphHeight = rect.height - (2 * graphPadding)
        let originX = graphPadding
        let originY = rect.height - graphPadding // Y-axis origin is at the bottom-left of the graph area

        // Ensure there's data to draw.
        guard !stepData.isEmpty else {
            // Optionally draw axes even if no data.
            drawAxes(in: context, graphRect: CGRect(x: originX, y: graphPadding, width: graphWidth, height: graphHeight))
            return
        }

        // Find the maximum step value to scale the Y-axis.
        guard let maxSteps = stepData.max(), maxSteps > 0 else {
            // If maxSteps is 0 or less, we can't scale properly.
            drawAxes(in: context, graphRect: CGRect(x: originX, y: graphPadding, width: graphWidth, height: graphHeight))
            return
        }

        // Calculate the horizontal spacing between data points.
        let xPointSpacing = graphWidth / CGFloat(stepData.count - 1)

        // Create the path for the line graph.
        let graphPath = UIBezierPath()
        var firstPoint = true

        for (index, steps) in stepData.enumerated() {
            // Calculate X position: index * spacing + originX
            let xPos = originX + (CGFloat(index) * xPointSpacing)

            // Calculate Y position: Scale steps to graph height.
            // (steps / maxSteps) gives a ratio from 0 to 1.
            // Multiply by graphHeight to get scaled height.
            // Subtract from originY because Y-axis increases upwards in graph, but downwards in CoreGraphics.
            let yPos = originY - ((steps / maxSteps) * graphHeight)

            let point = CGPoint(x: xPos, y: yPos)

            if firstPoint {
                graphPath.move(to: point)
                firstPoint = false
            } else {
                graphPath.addLine(to: point)
            }
        }

        // Draw the fill area under the line.
        let fillPath = graphPath.copy() as! UIBezierPath
        // Close the path to form a polygon for filling.
        fillPath.addLine(to: CGPoint(x: originX + graphWidth, y: originY)) // Bottom-right corner
        fillPath.addLine(to: CGPoint(x: originX, y: originY))             // Bottom-left corner
        fillPath.close()

        fillColor.setFill()
        fillPath.fill()

        // Draw the line.
        lineColor.setStroke()
        graphPath.lineWidth = lineWidth
        graphPath.stroke()

        // Draw axes and labels.
        drawAxes(in: context, graphRect: CGRect(x: originX, y: graphPadding, width: graphWidth, height: graphHeight))
        drawLabels(maxSteps: maxSteps, graphRect: CGRect(x: originX, y: graphPadding, width: graphWidth, height: graphHeight))
    }

    /// Draws the X and Y axes.
    private func drawAxes(in context: CGContext, graphRect: CGRect) {
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(1.0)

        // Draw Y-axis (vertical line on the left)
        context.move(to: CGPoint(x: graphRect.minX, y: graphRect.maxY))
        context.addLine(to: CGPoint(x: graphRect.minX, y: graphRect.minY))
        context.strokePath()

        // Draw X-axis (horizontal line at the bottom)
        context.move(to: CGPoint(x: graphRect.minX, y: graphRect.maxY))
        context.addLine(to: CGPoint(x: graphRect.maxX, y: graphRect.maxY))
        context.strokePath()
    }

    /// Draws labels for the axes.
    private func drawLabels(maxSteps: CGFloat, graphRect: CGRect) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.darkGray
        ]

        // Y-axis labels (e.g., 0, maxSteps/2, maxSteps)
        let yLabels = [0, Int(maxSteps / 2), Int(maxSteps)]
        for (index, labelValue) in yLabels.enumerated() {
            let yOffset: CGFloat
            if index == 0 {
                yOffset = graphRect.maxY - 5 // Slightly above the X-axis
            } else if index == 1 {
                yOffset = graphRect.midY - 5
            } else {
                yOffset = graphRect.minY - 5 // Slightly below the top of the graph area
            }

            let labelString = "\(labelValue)" as NSString
            let labelSize = labelString.size(withAttributes: textAttributes)
            let labelSizeWidth = labelSize.width + 5
            let labelRect = CGRect(x: graphRect.minX - labelSizeWidth, y: yOffset, width: labelSize.width, height: labelSize.height)
            labelString.draw(in: labelRect, withAttributes: textAttributes)
        }

        // X-axis labels (e.g., Day 1, Day 2, etc.)
        // For simplicity, we'll just label start and end.
        if stepData.count > 1 {
            let startLabel = "Day 1" as NSString
            let startLabelSize = startLabel.size(withAttributes: textAttributes)
            let startLabelRect = CGRect(x: graphRect.minX, y: graphRect.maxY + 5, width: startLabelSize.width, height: startLabelSize.height)
            startLabel.draw(in: startLabelRect, withAttributes: textAttributes)

            let endLabel = "Day \(stepData.count)" as NSString
            let endLabelSize = endLabel.size(withAttributes: textAttributes)
            let endLabelRect = CGRect(x: graphRect.maxX - endLabelSize.width, y: graphRect.maxY + 5, width: endLabelSize.width, height: endLabelSize.height)
            endLabel.draw(in: endLabelRect, withAttributes: textAttributes)
        } else if stepData.count == 1 {
            let singleDayLabel = "Day 1" as NSString
            let singleDayLabelSize = singleDayLabel.size(withAttributes: textAttributes)
            let singleDayLabelRect = CGRect(x: graphRect.midX - singleDayLabelSize.width / 2, y: graphRect.maxY + 5, width: singleDayLabelSize.width, height: singleDayLabelSize.height)
            singleDayLabel.draw(in: singleDayLabelRect, withAttributes: textAttributes)
        }
    }
}
