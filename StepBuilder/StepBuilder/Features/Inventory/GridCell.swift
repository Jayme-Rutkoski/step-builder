//
//  GridCell.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/19/25.
//

import UIKit

class GridCell: UICollectionViewCell {
    private let rightBorder = CALayer()
    private let bottomBorder = CALayer()
    private let topBevel = CALayer()
    private let leftBevel = CALayer()
    private let rightBevel = CALayer()
    private let bottomBevel = CALayer()

    // Config
    var lineWidth: CGFloat = 1 / UIScreen.main.scale
    var lineColor: UIColor = .separator
    var showsBevel: Bool = true
    var bevelAlpha: CGFloat = 0.25

    // set by VC
    private var isLastColumn = false
    private var isLastRow = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(hex: 0x800080)//.systemBackground

        // Optional “tile” shadow/rounding
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        rightBorder.cornerRadius = 6
        bottomBorder.cornerRadius = 6
        topBevel.cornerRadius = 6
        leftBevel.cornerRadius = 6
        rightBevel.cornerRadius = 6
        bottomBevel.cornerRadius = 6

        [rightBorder, bottomBorder, topBevel, leftBevel, rightBevel, bottomBevel].forEach {
            contentView.layer.addSublayer($0)
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        isLastColumn = false
        isLastRow = false
    }

    /// Call this from cellForItemAt
    func configure(indexPath: IndexPath, columns: Int, totalItems: Int) {
        let item = indexPath.item
        isLastColumn = (columns > 0) && ((item + 1) % columns == 0)
        let rows = max(1, Int(ceil(Double(totalItems) / Double(max(columns, 1)))))
        isLastRow = (item / max(columns, 1) == rows - 1)
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height

        // Borders: draw only right & bottom (hide on last col/row)
        rightBorder.backgroundColor = lineColor.cgColor
        bottomBorder.backgroundColor = lineColor.cgColor
        rightBorder.isHidden = isLastColumn
        bottomBorder.isHidden = isLastRow
        rightBorder.frame = CGRect(x: w - lineWidth, y: 0, width: lineWidth, height: h)
        bottomBorder.frame = CGRect(x: 0, y: h - lineWidth, width: w, height: lineWidth)

        // Bevel: highlight top/left, shadow right/bottom
        [topBevel, leftBevel, rightBevel, bottomBevel].forEach { $0.isHidden = !showsBevel }
        let hi = UIColor(white: 1, alpha: bevelAlpha).cgColor
        let lo = UIColor(white: 0, alpha: bevelAlpha * 0.85).cgColor
        topBevel.backgroundColor = hi
        leftBevel.backgroundColor = hi
        rightBevel.backgroundColor = lo
        bottomBevel.backgroundColor = lo
        topBevel.frame = CGRect(x: 0, y: 0, width: w, height: lineWidth)
        leftBevel.frame = CGRect(x: 0, y: 0, width: lineWidth, height: h)
        rightBevel.frame = CGRect(x: w - lineWidth * 2, y: 0, width: lineWidth, height: h)
        bottomBevel.frame = CGRect(x: 0, y: h - lineWidth * 2, width: w, height: lineWidth)
    }
}
