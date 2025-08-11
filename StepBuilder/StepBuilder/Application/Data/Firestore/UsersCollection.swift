//
//  UsersCollection.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//


//
//  RouletteCollection.swift
//  GhostPost
//
//  Created by Jayme Rutkoski on 11/20/24.
//

import Foundation
import Firebase

class UsersCollection: BaseCollection {
    
    private var lastSnapshot: DocumentSnapshot?
    
    override init() {
        
        super.init()
    }
    
    override public var collectionName: String {
        get {
            return "users"
        }
        set { }
    }
    
    public func getCurrentProgress() async -> FirestoreUserProgress? {
        if let userId = SwiftAppDefaults.shared.userId {
            let docRef = self.getCollection().document(userId).collection("currentProgress").document("data")
            if let document = try? await docRef.getDocument() {
                if document.exists {
                    if let progress = try? document.data(as: FirestoreUserProgress.self) {
                        return progress
                    }
                }
            }
        }
        
        return nil
    }
    
    public func saveCurrentProgress(currentGrid: [[Int]], currentDaySteps: Int, lastResetTimeStamp: Date) {
        if let userId = SwiftAppDefaults.shared.userId {
            let docRef = self.getCollection().document(userId).collection("currentProgress").document("data")
            do {
                let gridJsonData = try JSONEncoder().encode(currentGrid)
                let gridJsonString = String(data: gridJsonData, encoding: .utf8) ?? "[]"
                
                let progress = FirestoreUserProgress()
                progress.userId = userId
                progress.currentGridState = gridJsonString
                progress.currentDaySteps = currentDaySteps
                progress.lastResetTimestamp = Timestamp(date: lastResetTimeStamp)
                try docRef.setData(from: progress)
                print("Saved current progress: Steps=\(currentDaySteps), Last Reset=\(lastResetTimeStamp.formattedAsYYYYMMDD())")
                
            } catch {
                print("Error saving current progress: \(error.localizedDescription)")
            }
        }
    }
    
    public func updateDailyGrid(grid: [[Int]], forDate: Date) async {
        if let userId = SwiftAppDefaults.shared.userId {
            let docRef = self.getCollection().document(userId).collection("dailyGrids").document("\(forDate.formattedAsYYYYMMDD())")
            
            do {
                let gridJsonData = try JSONEncoder().encode(grid)
                let gridJsonString = String(data: gridJsonData, encoding: .utf8) ?? "[]"

                let data: [String: Any] = [
                    "grid": gridJsonString,
                ]
                try await docRef.updateData(data)
            } catch {
                print("Error saving current progress: \(error.localizedDescription)")
            }
        }
    }
    
    public func saveDailyGridToHistory(steps: Int, grid: [[Int]], date: Date) {
        if let userId = SwiftAppDefaults.shared.userId {
            let collectionRef = self.getCollection().document(userId).collection("dailyGrids")
            
            let docId = date.formattedAsYYYYMMDD()
            
            do {
                let gridJsonData = try JSONEncoder().encode(grid)
                let gridJsonString = String(data: gridJsonData, encoding: .utf8) ?? "[]"
                
                let dailyGrid = FirestoreDailyGrid()
                dailyGrid.steps = steps
                dailyGrid.grid = gridJsonString
                dailyGrid.timestamp = Timestamp(date: date)
                
                try collectionRef.document(docId).setData(from: dailyGrid)
                print("Saved daily history for \(docId): Steps=\(steps)")
            } catch {
                print("Error saving daily grid to history: \(error.localizedDescription)")
            }
        }
    }
    
    public func getGridForDate(_ date: Date) async -> ([[Int]], Date)? {
        if let userId = SwiftAppDefaults.shared.userId {
            let collectionRef = self.getCollection().document(userId).collection("dailyGrids")
            
            if let document = try? await collectionRef.document(date.formattedAsYYYYMMDD()).getDocument() {
                if let dailyGrid = try? document.data(as: FirestoreDailyGrid.self) {
                    
                    if let jsonData = dailyGrid.grid.data(using: .utf8) {
                        do {
                            let decodedData = try JSONDecoder().decode([[Int]].self, from: jsonData)
                            return (decodedData, dailyGrid.timestamp.dateValue())
                        } catch {
                            print("Error decoding JSON: \(error)")
                            return nil
                        }
                    } else {
                        return nil
                    }
                }
            }
        }
        
        return nil
    }
}
