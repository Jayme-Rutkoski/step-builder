//
//  HealthHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/29/25.
//
import Foundation
import HealthKit
import CoreMotion

class HealthHelper {
    
    private static func fetchPedometerStepCount(fromDate: Date, numberOfDays: Int, completion: @escaping ([CGFloat]) -> Void) {
        var dailyStepCounts: [CGFloat] = Array(repeating: 0.0, count: numberOfDays)
        let calendar = Calendar.current
        let now = Date()

        // Create a dispatch group to wait for all queries to complete.
        let dispatchGroup = DispatchGroup()

        for i in 0..<numberOfDays {
            dispatchGroup.enter()

            // Calculate the start of the day 'i' days ago
            guard let dateForDay = calendar.date(byAdding: .day, value: -i, to: fromDate),
                  let startDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: dateForDay) else {
                dispatchGroup.leave()
                continue
            }

            // Determine the end date for the query
            let endDate: Date
            if i == 0 {
                // For the current day, fetch data up to the current moment
                endDate = now
            } else {
                // For past days, fetch data up to the very end of that day
                // This gets the start of the next day, which is the exclusive end for the predicate
                guard let endOfPreviousDay = calendar.date(byAdding: .day, value: 1, to: startDate) else {
                    dispatchGroup.leave()
                    continue
                }
                endDate = endOfPreviousDay
            }
            
            Factory.shared().pedometer.queryPedometerData(from: startDate, to: endDate) { result, error in
                defer { dispatchGroup.leave() } // Ensure we leave the group even if there's an error

                if let error = error {
                    print("Error fetching step count for day \(i): \(error.localizedDescription)")
                    return
                }

                guard let sum = result?.numberOfSteps else {
                    // No data for this day, step count remains 0.0
                    return
                }

                var steps = sum.doubleValue
                
                let virtualSteps = SwiftAppDefaults.shared.virtualStepsHistory
                for dateStep in virtualSteps.keys {
                    if (dateStep.isSameDay(as: startDate)) {
                        steps += Double(virtualSteps[dateStep] ?? 0)
                    }
                }
                
                // Store the steps for the correct day (reverse order for graph display: oldest to newest)
                dailyStepCounts[numberOfDays - 1 - i] = CGFloat(steps)
            }
        }

        // Notify when all queries are done.
        dispatchGroup.notify(queue: .main) {
            completion(dailyStepCounts)
        }
    }
    
    private static func fetchStepCount(fromDate: Date, numberOfDays: Int, completion: @escaping ([CGFloat]) -> Void) {
        let healthStore = HKHealthStore()
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion([])
            return
        }

        var dailyStepCounts: [CGFloat] = Array(repeating: 0.0, count: numberOfDays)
        let calendar = Calendar.current
        let now = Date()

        // Create a dispatch group to wait for all queries to complete.
        let dispatchGroup = DispatchGroup()

        for i in 0..<numberOfDays {
            dispatchGroup.enter()

            // Calculate the start of the day 'i' days ago
            guard let dateForDay = calendar.date(byAdding: .day, value: -i, to: fromDate),
                  let startDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: dateForDay) else {
                dispatchGroup.leave()
                continue
            }

            // Determine the end date for the query
            let endDate: Date
            if i == 0 {
                // For the current day, fetch data up to the current moment
                endDate = now
            } else {
                // For past days, fetch data up to the very end of that day
                // This gets the start of the next day, which is the exclusive end for the predicate
                guard let endOfPreviousDay = calendar.date(byAdding: .day, value: 1, to: startDate) else {
                    dispatchGroup.leave()
                    continue
                }
                endDate = endOfPreviousDay
            }

            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)

            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                defer { dispatchGroup.leave() } // Ensure we leave the group even if there's an error

                if let error = error {
                    print("Error fetching step count for day \(i): \(error.localizedDescription)")
                    return
                }

                guard let sum = result?.sumQuantity() else {
                    // No data for this day, step count remains 0.0
                    return
                }

                let steps = sum.doubleValue(for: HKUnit.count())
                // Store the steps for the correct day (reverse order for graph display: oldest to newest)
                dailyStepCounts[numberOfDays - 1 - i] = CGFloat(steps)
            }
            healthStore.execute(query)
        }

        // Notify when all queries are done.
        dispatchGroup.notify(queue: .main) {
            completion(dailyStepCounts)
        }
    }
    
    static func fetchStepCount(forDate date: Date, completion: @escaping (CGFloat) -> Void) {
        fetchPedometerStepCount(fromDate: date, numberOfDays: 1) { stepCounts in
            completion(stepCounts.first ?? 0.0)
        }
    }
    
    static func fetchDailyStepCounts(forLast numberOfDays: Int, completion: @escaping ([CGFloat]) -> Void ) {
        fetchPedometerStepCount(fromDate: .now, numberOfDays: numberOfDays) { stepCounts in
            completion(stepCounts)
        }
    }
}
