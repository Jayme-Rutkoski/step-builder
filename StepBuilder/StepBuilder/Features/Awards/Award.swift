//
//  Award.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/7/25.
//
import Foundation
import UIKit

class Award {
    var name: String
    var progress: CGFloat?
    var completionTimes: Int?
    var image: UIImage?
    var isCompleted: Bool
    
    init(name: String, progress: CGFloat, image: UIImage?, isCompleted: Bool) {
        self.name = name
        self.progress = progress
        self.image = image
        self.isCompleted = isCompleted
    }
    
    init(name: String, completionTimes: Int, image: UIImage?, isCompleted: Bool) {
        self.name = name
        self.completionTimes = completionTimes
        self.image = image
        self.isCompleted = isCompleted
    }
}
