//
//  MonsterHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/6/25.
//
import Foundation

class MonsterHelper {
    static func calculateNewFind() -> Int {
        var randomValue = Int.random(in: 0...100)
        if (randomValue <= 30) {
            // 60% chance to find nothing
            return 99999
        } else {
            randomValue = generateRandomNumberDivisibleByTen(in: 10...60) ?? 99999
            SwiftAppDefaults.addMonster(randomValue)
            NotificationCenter.default.post(name: .MonsterFound, object: randomValue)
            return randomValue
        }
    }
    
    private static func generateRandomNumberDivisibleByTen(in range: ClosedRange<Int>) -> Int? {
        // Check if the range is valid
        guard range.lowerBound <= range.upperBound else {
            return nil
        }

        // Find the closest multiple of 10 at or after the lower bound
        var start = range.lowerBound
        if start % 10 != 0 {
            start = start + (10 - (start % 10))
        }

        // Check if there are any multiples of 10 in the range
        if start > range.upperBound {
            return nil
        }

        // Calculate the number of multiples of 10 in the range
        let count = (range.upperBound - start) / 10 + 1

        // Generate a random index and multiply by 10
        let randomIndex = Int.random(in: 0..<count)
        return start + (randomIndex * 10)
    }
}
