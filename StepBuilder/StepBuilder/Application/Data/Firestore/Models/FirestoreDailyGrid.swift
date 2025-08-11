//
//  FirestoreDailyGrid.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//

import Foundation
import Firebase

public class FirestoreDailyGrid: Codable {
    public var steps: Int = 0
    public var grid: String = ""
    public var timestamp: Timestamp = Timestamp(date: Date())
    
    init() { }
}
