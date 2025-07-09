//
//  Rotation.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/8/25.
//


import Foundation

enum Rotation: Int {
    case degrees45 = 45
    case degrees135 = 135
    case degrees225 = 225
    case degrees315 = 315
    
    static var defaultRotation: Rotation {
        .degrees45
    }
}
