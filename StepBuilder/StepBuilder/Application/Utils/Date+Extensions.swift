//
//  Date+Extensions.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/23/25.
//
import Foundation

extension Date {
    func formattedAsYYYYMMDD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
    
    func getPastDate(byDays days: Int) -> Date? {
        // Get today's date
        let calendar = Calendar.current
        
        // Example for a past date (e.g., 30 days ago)
        let daysToSubtract = -days
        var pastDateComponents = DateComponents()
        pastDateComponents.day = daysToSubtract
        
        if let pastDate = calendar.date(byAdding: pastDateComponents, to: self) {
            return pastDate
        } else {
            return nil
        }
    }
}
