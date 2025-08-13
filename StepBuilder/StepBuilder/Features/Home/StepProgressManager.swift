//
//  StepProgressManager.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/23/25.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

class StepProgressManager {
    // Current day's steps and grid state
    private var currentDaySteps: Int = 0
    private var lastGridResetDate: Date = Date()
    private lazy var currentGrid: [[Int]] = createGrid(rows: 5, cols: 5, initialValue: 1)

    func createGrid<T>(rows: Int, cols: Int, initialValue: T) -> [[T]] {
        // Initialize an empty array to hold the rows of the grid.
        var grid: [[T]] = []

        // Loop through each row.
        for _ in 0..<rows {
            // Initialize an empty array for the current row.
            var row: [T] = []
            // Loop through each column in the current row.
            for _ in 0..<cols {
                // Add the initial value to the current cell.
                row.append(initialValue)
            }
            // Add the completed row to the grid.
            grid.append(row)
        }

        // Return the generated grid.
        return grid
    }
    
    func generatePlantProgressGrid(totalSteps: Int) -> [[Int]] {
        let rows = 5
        let cols = 5
        let stepsPerLevelUp = Int(Constants.stepsPerLevelUp)
        let stepsToUse = totalSteps
        let numTotalUpgrades = stepsToUse / stepsPerLevelUp
        
        var grid = self.currentGrid
        
        var numOfExistingUpgrades = -25 // Start with -25 to account for the initial dirt state
        for r in 0..<rows {
            for c in 0..<cols {
                var gridVal = grid[r][c]
                if (gridVal > 2) {
                    gridVal = 2
                }
                numOfExistingUpgrades += gridVal
            }
        }
        
        let numUpgradesToApply = numTotalUpgrades - numOfExistingUpgrades

        var upgradeOpportunities: [(row: Int, col: Int)] = []
        for r in 0..<rows {
            for c in 0..<cols {
                upgradeOpportunities.append((row: r, col: c)) // For 1 -> 2
            }
        }

        upgradeOpportunities.shuffle()

        var upgradesAppliedCount = 0
        for opportunity in upgradeOpportunities {
            if upgradesAppliedCount >= numUpgradesToApply {
                break
            }

            let r = opportunity.row
            let c = opportunity.col

            if grid[r][c] < 2 {
                var newValue = grid[r][c] + 1
                if (newValue == 2) {
                    newValue = MonsterHelper.calculateNewFind()
                }
                grid[r][c] = newValue
                upgradesAppliedCount += 1
            }
        }
        
        let legacyCheckResult = legacyValueCheck(grid: grid)
        if (legacyCheckResult.1) {
            grid = legacyCheckResult.0 // Update grid if legacy values were found and replaced
        }

        return grid
    }
    
    // Authenticate user and load progress
    func initializeAndLoadProgress(completion: @escaping () -> Void) {
        Task {
            await loadCurrentProgress()
            completion()
        }
    }
    
    // Check for legacy values in the grid
    private func legacyValueCheck(grid: [[Int]]) -> ([[Int]], Bool) {
        let rows = 5
        let cols = 5
        var grid = grid
        var didChange = false
        // Check for legacy values
        for r in 0..<rows {
            for c in 0..<cols {
                if grid[r][c] == 3 || grid[r][c] == 2 {
                    let newValue = MonsterHelper.calculateNewFind()
                    grid[r][c] = newValue // Replace legacy value with a new monster find
                    didChange = true
                }
            }
        }
        
        return (grid, didChange)
    }

    // Load current progress from Firestore
    private func loadCurrentProgress() async {
        if let progress = await Factory.shared().usersCollection.getCurrentProgress() {
            self.currentDaySteps = progress.currentDaySteps
            self.lastGridResetDate = progress.lastResetTimestamp.dateValue()
            if let gridData = progress.currentGridState.data(using: .utf8) {
                do {
                    let decodedGrid = try JSONDecoder().decode([[Int]].self, from: gridData)
                    self.currentGrid = decodedGrid
                } catch {
                    print("Error decoding saved grid: \(error.localizedDescription)")
                    self.currentGrid = createGrid(rows: 5, cols: 5, initialValue: 1) // Reset if decoding fails
                }
            }
            print("Loaded current progress: Steps=\(currentDaySteps), Last Reset=\(lastGridResetDate.formattedAsYYYYMMDD())")
        } else {
            print("No existing progress found. Initializing new progress.")
            // If no document exists, save the initial state
            saveCurrentProgress()
        }
        
        // Check for daily reset after loading
        await checkForDailyReset()
    }

    // Save current progress to Firestore
    private func saveCurrentProgress() {
        self.checkPerfectStreakCount(steps: currentDaySteps, date: lastGridResetDate)
        
        Factory.shared().usersCollection.saveCurrentProgress(currentGrid: currentGrid, currentDaySteps: currentDaySteps, lastResetTimeStamp: lastGridResetDate)
    }
    
    private func saveGrid(grid: [[Int]], forDate: Date) async {
        
        await Factory.shared().usersCollection.updateDailyGrid(grid: grid, forDate: forDate)
    }

    // Check if it's a new day and handle reset/history save
    private func checkForDailyReset() async {
        let today = Date()
        if !today.isSameDay(as: lastGridResetDate) {
            print("New day detected! Resetting grid and saving yesterday's progress.")
            // Save yesterday's grid to history
            await saveDailyGridToHistory(steps: currentDaySteps, date: lastGridResetDate)

            // Reset for the new day
            currentDaySteps = 0
            lastGridResetDate = today
            currentGrid = createGrid(rows: 5, cols: 5, initialValue: 1) // Start new grid as dirt
            saveCurrentProgress() // Save the reset state
        } else {
            print("Still the same day. Continuing with current progress.")
            // Recalculate grid based on currentDaySteps in case steps were added without app restart
            currentGrid = generatePlantProgressGrid(totalSteps: currentDaySteps)
            saveCurrentProgress() // Ensure the grid state is up-to-date in Firestore
        }
    }

    // Save a daily grid snapshot to history
    private func saveDailyGridToHistory(steps: Int, date: Date) async {
        HealthHelper.fetchStepCount(forDate: date) { daySteps in
            let stepsDiff = Int(daySteps) - steps
            SwiftAppDefaults.shared.totalStepsTaken += stepsDiff
            self.checkPerfectStreakCount(steps: Int(daySteps), date: date)
            let grid = self.generatePlantProgressGrid(totalSteps: Int(daySteps))
            
            Factory.shared().usersCollection.saveDailyGridToHistory(steps: Int(daySteps), grid: grid, date: date)
        }
    }
    
    private func checkPerfectStreakCount(steps: Int, date: Date) {
        if (!SwiftAppDefaults.shared.lastPerfectStreak.isSameDay(as: date)) {
            if (steps >= Int(Constants.stepGoal)) {
                SwiftAppDefaults.shared.lastPerfectStreak = date
                SwiftAppDefaults.shared.perfectStreakCount += 1
                
                if (!SwiftAppDefaults.shared.hasPerfectDay && SwiftAppDefaults.shared.perfectStreakCount >= 1) {
                    SwiftAppDefaults.shared.hasPerfectDay = true
                    // Post Notification
                } else if (!SwiftAppDefaults.shared.hasPerfectWeek && SwiftAppDefaults.shared.perfectStreakCount >= 7) {
                    SwiftAppDefaults.shared.hasPerfectWeek = true
                    // Post Notification
                } else if (!SwiftAppDefaults.shared.hasPerfectMonth && SwiftAppDefaults.shared.perfectStreakCount >= 30) {
                    SwiftAppDefaults.shared.hasPerfectMonth = true
                    // Post Notification
                }
            } else {
                SwiftAppDefaults.shared.perfectStreakCount = 0
            }
        }
    }

    // Public method to add steps for the current day
    func addSteps(steps: Int) async {
        if (SwiftAppDefaults.shared.totalStepsTaken == 0) {
            SwiftAppDefaults.shared.totalStepsTaken += steps
        } else {
            SwiftAppDefaults.shared.totalStepsTaken += steps - currentDaySteps
        }
            
        currentGrid = generatePlantProgressGrid(totalSteps: steps)
        currentDaySteps = steps
        saveCurrentProgress()
        print("Added \(steps) steps. Current total for today: \(currentDaySteps)")
    }

    // Public method to get the current grid
    func getCurrentGrid() -> [[Int]] {
        return currentGrid
    }
    
    func getCurrentSteps() -> Int {
        return currentDaySteps
    }
    
    func getGridForDate(_ date: Date) async -> [[Int]]? {
        if let result = await Factory.shared().usersCollection.getGridForDate(date) {
            var decodedData = result.0
            let legacyCheckResult = legacyValueCheck(grid: decodedData)
            if (legacyCheckResult.1) {
                decodedData = legacyCheckResult.0 // Update grid if legacy values were found and replaced
                await self.saveGrid(grid: decodedData, forDate: result.1) // Save the updated grid
            }
            return decodedData
        } else {
            return nil
        }
    }
}
