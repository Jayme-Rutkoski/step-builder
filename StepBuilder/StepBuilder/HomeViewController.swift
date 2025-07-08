//
//  ViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/7/25.
//

import UIKit
import SpriteKit
import HealthKit

class HomeViewController: UIViewController {

    private var scene: SKScene?
    private let healthStore = HKHealthStore()
    
    private var labelSteps: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var skView: SKView = {
        let view = SKView(frame: self.view.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.ignoresSiblingOrder = true
        view.showsFPS = false
        view.showsNodeCount = false
        view.showsPhysics = false
        
        return view
    }()
    
    private var lineGraphView: StepLineGraphView = {
        let graphView = StepLineGraphView(frame: .zero)
        graphView.lineColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        graphView.fillColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 0.2)
        graphView.lineWidth = 3.0
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.stepData = [
            7500, 8200, 6800, 9500, 7000, 10500, 9000
        ]
        
        return graphView
    }()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        self.setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scene?.size = self.view.bounds.size
        skView.presentScene(scene)
    }


    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscapeLeft
        } else {
            return .all
        }
    }
    
    func setup() {
        self.view.addSubview(self.labelSteps)
        self.labelSteps.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.view.addSubview(lineGraphView)
        self.lineGraphView.snp.makeConstraints { make in
            make.top.equalTo(self.labelSteps.snp.bottom).offset(16)
            make.left.equalTo(self.view.snp.left).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-5)
            make.bottom.equalTo(self.view.snp.centerY)
        }
        
        self.view.addSubview(skView)
        skView.snp.makeConstraints { make in
            make.top.equalTo(self.lineGraphView.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        self.authorizeHealthKit()
        
    }
    
    private func authorizeHealthKit() {
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ] // We want to access the step count.
        let status = healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .stepCount)!) // Check the authorization status for step count.
        switch status {
        case .sharingAuthorized:
            self.calculateSteps()
        case .notDetermined:
            healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
                if success {
                    self.calculateSteps()
                }
            }
        case .sharingDenied:
            print("DENIED")
        @unknown default:
            print("UNKNOWN AUTHORIZATION STATUS")
        }
    }
    
    func calculateSteps() {
        self.fetchDailyStepCounts(forLast: 7) { dailySteps in
            print("DAILY STEPS: \(dailySteps)")
            self.lineGraphView.stepData = dailySteps
            self.labelSteps.text = "Steps: \(dailySteps.last ?? 0)"
        }
    }
    
    func fetchDailyStepCounts(forLast numberOfDays: Int, completion: @escaping ([CGFloat]) -> Void) {
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
                guard let dateForDay = calendar.date(byAdding: .day, value: -i, to: now),
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
    
    public func setScene(scene: SKScene) {
        scene.scaleMode = .aspectFill
        self.scene = scene
    }
}

