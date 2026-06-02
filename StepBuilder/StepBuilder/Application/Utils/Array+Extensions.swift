//
//  Array+Extensions.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 6/1/2026.
//

extension Array {
    /// Removes up to a maximum number of elements that match the given predicate.
    mutating func remove(amount: Int, where predicate: (Element) -> Bool) {
        var removedCount = 0
        // Loop backwards so indices don't shift out from under you while deleting
        for index in stride(from: self.count - 1, through: 0, by: -1) {
            guard removedCount < amount else { break }
            
            if predicate(self[index]) {
                self.remove(at: index)
                removedCount += 1
            }
        }
    }
}
