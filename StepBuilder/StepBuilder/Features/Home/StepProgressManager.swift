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
    private var db: Firestore!

    // Current day's steps and grid state
    private var currentDaySteps: Int = 0
    private var lastGridResetDate: Date = Date()
    private lazy var currentGrid: [[Int]] = createGrid(rows: 5, cols: 5, initialValue: 1)

    init() {
        // Initialize Firebase app if not already initialized
        self.db = Firestore.firestore()
    }

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
        let stepsPerLevelUp = 250 // 40,000 steps to max out entire grid (5x5 * 2 levels * 800 steps/level)
        let stepsToUse = totalSteps
        let numTotalUpgrades = stepsToUse / stepsPerLevelUp
        
        var grid = self.currentGrid
        
        var numOfExistingUpgrades = -25 // Start with -25 to account for the initial dirt state
        for r in 0..<rows {
            for c in 0..<cols {
                numOfExistingUpgrades += grid[r][c]
            }
        }
        
        let numUpgradesToApply = numTotalUpgrades - numOfExistingUpgrades

        var upgradeOpportunities: [(row: Int, col: Int)] = []
        for r in 0..<rows {
            for c in 0..<cols {
                upgradeOpportunities.append((row: r, col: c)) // For 1 -> 2
                upgradeOpportunities.append((row: r, col: c)) // For 2 -> 3
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

            if grid[r][c] < 3 {
                grid[r][c] += 1
                upgradesAppliedCount += 1
            }
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

    // Load current progress from Firestore
    private func loadCurrentProgress() async {
        guard let userId = SwiftAppDefaults.shared.userId else {
            print("User ID not available for loading progress.")
            return
        }

        let docRef = db.collection("users").document(userId).collection("currentProgress").document("data")

        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let data = document.data()
                self.currentDaySteps = data?["currentDaySteps"] as? Int ?? 0
                if let timestamp = data?["lastResetTimestamp"] as? Timestamp {
                    self.lastGridResetDate = timestamp.dateValue()
                }
                if let gridJsonString = data?["currentGridState"] as? String {
                    if let gridData = gridJsonString.data(using: .utf8) {
                        do {
                            let decodedGrid = try JSONDecoder().decode([[Int]].self, from: gridData)
                            self.currentGrid = decodedGrid
                        } catch {
                            print("Error decoding saved grid: \(error.localizedDescription)")
                            self.currentGrid = createGrid(rows: 5, cols: 5, initialValue: 1) // Reset if decoding fails
                        }
                    }
                }
                print("Loaded current progress: Steps=\(currentDaySteps), Last Reset=\(lastGridResetDate.formattedAsYYYYMMDD())")
            } else {
                print("No existing progress found. Initializing new progress.")
                // If no document exists, save the initial state
                await saveCurrentProgress()
            }

            // Check for daily reset after loading
            await checkForDailyReset()

        } catch {
            print("Error loading current progress: \(error.localizedDescription)")
            // If loading fails, ensure we have a default grid
            self.currentGrid = createGrid(rows: 5, cols: 5, initialValue: 1)
            self.currentDaySteps = 0
            self.lastGridResetDate = Date()
        }
    }

    // Save current progress to Firestore
    private func saveCurrentProgress() async {
        guard let userId = SwiftAppDefaults.shared.userId else {
            print("User ID not available for saving progress.")
            return
        }

        let docRef = db.collection("users").document(userId).collection("currentProgress").document("data")

        do {
            let gridJsonData = try JSONEncoder().encode(currentGrid)
            let gridJsonString = String(data: gridJsonData, encoding: .utf8) ?? "[]"

            let data: [String: Any] = [
                "currentDaySteps": currentDaySteps,
                "lastResetTimestamp": Timestamp(date: lastGridResetDate),
                "currentGridState": gridJsonString,
                "userId": userId // Store userId for clarity in Firestore
            ]
            try await docRef.setData(data)
            print("Saved current progress: Steps=\(currentDaySteps), Last Reset=\(lastGridResetDate.formattedAsYYYYMMDD())")
        } catch {
            print("Error saving current progress: \(error.localizedDescription)")
        }
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
            await saveCurrentProgress() // Save the reset state
        } else {
            print("Still the same day. Continuing with current progress.")
            // Recalculate grid based on currentDaySteps in case steps were added without app restart
            currentGrid = generatePlantProgressGrid(totalSteps: currentDaySteps)
            await saveCurrentProgress() // Ensure the grid state is up-to-date in Firestore
        }
    }

    // Save a daily grid snapshot to history
    private func saveDailyGridToHistory(steps: Int, date: Date) async {
        guard let userId = SwiftAppDefaults.shared.userId else {
            print("User ID not available for saving daily history.")
            return
        }
        HealthHelper.fetchStepCount(forDate: date) { daySteps in
            let historyCollectionRef = self.db.collection("users").document(userId).collection("dailyGrids")
            let docId = date.formattedAsYYYYMMDD() // Use date as document ID
            let grid = self.generatePlantProgressGrid(totalSteps: Int(daySteps))
            
            do {
                let gridJsonData = try JSONEncoder().encode(grid)
                let gridJsonString = String(data: gridJsonData, encoding: .utf8) ?? "[]"
                
                let data: [String: Any] = [
                    "steps": Int(daySteps),
                    "grid": gridJsonString,
                    "timestamp": Timestamp(date: date)
                ]
                historyCollectionRef.document(docId).setData(data)
                print("Saved daily history for \(docId): Steps=\(steps)")
            } catch {
                print("Error saving daily grid to history: \(error.localizedDescription)")
            }
        }
    }

    // Public method to add steps for the current day
    func addSteps(steps: Int) async {
        currentGrid = generatePlantProgressGrid(totalSteps: steps)
        currentDaySteps = steps
        await saveCurrentProgress()
        print("Added \(steps) steps. Current total for today: \(currentDaySteps)")
    }

    // Public method to get the current grid
    func getCurrentGrid() -> [[Int]] {
        return currentGrid
    }
    
    func getGridForDate(_ date: Date) async -> [[Int]]? {
        guard let userId = SwiftAppDefaults.shared.userId else {
            print("User ID not available for fetching history.")
            return nil
        }
        
        let historyCollectionRef = db.collection("users").document(userId).collection("dailyGrids")
        
        let doc = try? await historyCollectionRef.document(date.formattedAsYYYYMMDD()).getDocument()
        let grid = doc?.data()?["grid"] as? String
        
        if let jsonData = grid?.data(using: .utf8) {
            do {
                let decodedData = try JSONDecoder().decode([[Int]].self, from: jsonData)
                return decodedData
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }

    // Public method to get historical grids
    func getDailyHistory(completion: @escaping ([[String: Any]]) -> Void) {
        guard let userId = SwiftAppDefaults.shared.userId else {
            print("User ID not available for fetching history.")
            completion([])
            return
        }

        let historyCollectionRef = db.collection("users").document(userId).collection("dailyGrids")

        // Fetch all documents in the dailyGrids collection
        historyCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting daily history: \(error.localizedDescription)")
                completion([])
            } else {
                var history: [[String: Any]] = []
                for document in querySnapshot!.documents {
                    var data = document.data()
                    // Convert grid JSON string back to [[Int]] if needed for display
                    if let gridJsonString = data["grid"] as? String, let gridData = gridJsonString.data(using: .utf8) {
                        do {
                            let decodedGrid = try JSONDecoder().decode([[Int]].self, from: gridData)
                            data["grid"] = decodedGrid // Replace string with actual array
                        } catch {
                            print("Error decoding history grid for \(document.documentID): \(error.localizedDescription)")
                        }
                    }
                    history.append(data)
                }
                // Sort history by date if desired
                history.sort { (item1, item2) -> Bool in
                    if let ts1 = item1["timestamp"] as? Timestamp, let ts2 = item2["timestamp"] as? Timestamp {
                        return ts1.dateValue() < ts2.dateValue()
                    }
                    return false
                }
                completion(history)
            }
        }
    }

    // Public method to get the current user ID
    func getUserId() -> String {
        return SwiftAppDefaults.shared.userId ?? "Unknown User"
    }
}
