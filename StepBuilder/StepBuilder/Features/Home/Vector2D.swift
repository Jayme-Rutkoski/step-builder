//
//  Vector2D.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/8/25.
//


import Foundation

struct Vector2D { 
    var x: Int
    var y: Int
    
    static var zero: Vector2D {
        Vector2D(x: 0, y: 0)
    }
    
    static func +(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(scalar: Int, vector: Vector2D) -> Vector2D {
        Vector2D(x: scalar * vector.x, y: scalar * vector.y)
    }
}

extension Vector2D: Hashable { }
