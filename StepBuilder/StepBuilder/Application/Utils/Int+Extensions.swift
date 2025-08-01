//
//  Int+Extensions.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/29/25.
//
import UIKit

extension Int {

    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) else {
            return String(self)
        }
        return formattedNumber
    }
}
