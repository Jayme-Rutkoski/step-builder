//
//  IsoConverter.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/8/25.
//

import Foundation

func convertWorldToScreen(_ worldSpacePosition: Vector3D, spriteSize: CGSize, direction: Rotation = .defaultRotation) -> Vector2D {
    let xYValue = calculateXYPoint(width: spriteSize.width)
    
    let xOffset = Vector2D(x: xYValue.0, y: xYValue.1)
    let yOffset = Vector2D(x: -xYValue.0, y: xYValue.1)
    let zOffset = Vector2D(x: 0, y: xYValue.1)
    
    let rotatedWorldSpacePosition = rotateCoordinate(worldSpacePosition, direction: direction)
    
    return rotatedWorldSpacePosition.x * xOffset + rotatedWorldSpacePosition.y * yOffset + rotatedWorldSpacePosition.z * zOffset
}

func convertWorldToZPosition(_ worldSpacePosition: Vector3D, spriteSize: CGSize, direction: Rotation = .defaultRotation) -> Int {
    let xYValue = calculateXYPoint(width: spriteSize.width)
    return -convertWorldToScreen(worldSpacePosition, spriteSize: spriteSize, direction: direction).y + worldSpacePosition.z * xYValue.1 * 2
}

func rotateCoordinate(_ coord: Vector3D, direction: Rotation) -> Vector3D {
    switch direction {
    case .degrees45:
        return coord
    case .degrees225:
        return Vector3D(x: -coord.x, y: -coord.y, z: coord.z)
    case .degrees315:
        return Vector3D(x: coord.y, y: -coord.x, z: coord.z)
    case .degrees135:
        return Vector3D(x: -coord.y, y: coord.x, z: coord.z)
    }
}

func calculateXYPoint(width: CGFloat) -> (Int, Int) {
    let xValue = Int(width / 2)
    let yValue = Int(Float(xValue) * tan(Float((30 * (Double.pi / 180.0)))))
    
    return (xValue, yValue)
}
