//
//  FirestoreUserProgress.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//


import Foundation
import Firebase

public class FirestoreUserProgress: Codable {
    public var userId: String = ""
    public var currentDaySteps: Int = 0
    public var currentGridState: String = ""
    public var lastResetTimestamp: Timestamp = Timestamp(date: Date())
    
    init() { }
}
