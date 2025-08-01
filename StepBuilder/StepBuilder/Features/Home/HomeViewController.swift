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

    private var scene: IsometricScene?
    private let healthStore = HKHealthStore()
    private let stepGoal: CGFloat = 10000.0
    private var pageIndex: CGFloat = 0.0
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        return scrollView
    }()
    private var labelSteps: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    private lazy var labelStepsGoal: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.text = "of \(Int(self.stepGoal).withCommas()) steps"
        
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
    
    private var circleGraphView: CircularProgressGraphView = {
        let graphView = CircularProgressGraphView(frame: .zero)
        
        return graphView
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
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalTo(self.view.snp.left).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-5)
            //make.bottom.equalTo(self.view.snp.centerY).offset(-16)
            make.height.equalTo(300)
        }
        
        self.view.addSubview(skView)
        skView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.bottom)
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
        HealthHelper.fetchDailyStepCounts(forLast: 7) { dailySteps in
            let containerView = UIView(frame: .zero)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.right.equalTo(self.scrollView.contentLayoutGuide.snp.right)
                make.left.equalTo(self.scrollView.contentLayoutGuide.snp.left)
                make.top.equalTo(self.scrollView.contentLayoutGuide.snp.top)
                make.bottom.equalTo(self.scrollView.contentLayoutGuide.snp.bottom)
                make.height.equalTo(self.scrollView.frameLayoutGuide.snp.height)
            }

            
            var previousView: UIView?
            
            for (data) in dailySteps.enumerated().reversed() {
                let steps = Int(data.element)
                let stackView = UIStackView(frame: .zero)
                stackView.axis = .vertical
                stackView.alignment = .center
                stackView.spacing = 5
                
                let titleLabel = UILabel(frame: .zero)
                titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
                titleLabel.textColor = .black
                titleLabel.text = Int(steps).withCommas()
                
                stackView.addArrangedSubview(titleLabel)
                
                let subtitleLabel = UILabel(frame: .zero)
                subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                subtitleLabel.textColor = .black
                subtitleLabel.text = "of \(Int(self.stepGoal).withCommas()) steps"
                
                stackView.addArrangedSubview(subtitleLabel)
                
                let progressView = CircularProgressGraphView(frame: .zero)
                progressView.progress = CGFloat(steps) / self.stepGoal
                stackView.addArrangedSubview(progressView)
                containerView.addSubview(stackView)

                if let previousView = previousView {
                    stackView.snp.makeConstraints { make in
                        make.width.equalTo(self.scrollView.frameLayoutGuide.snp.width)
                        make.height.equalTo(self.scrollView.frameLayoutGuide.snp.height)
                        make.centerY.equalTo(containerView.snp.centerY)
                        make.right.equalTo(previousView.snp.left)
                    }
                } else {
                    stackView.snp.makeConstraints { make in
                        make.width.equalTo(self.scrollView.frameLayoutGuide.snp.width)
                        make.height.equalTo(self.scrollView.frameLayoutGuide.snp.height)
                        make.centerY.equalTo(containerView.snp.centerY)
                        make.right.equalTo(containerView.snp.right)
                    }
                }
                
                previousView = stackView
                
                progressView.snp.makeConstraints { make in
                    make.height.equalTo(250)
                    make.width.equalTo(250)
                }
            }
            
            
            if let lastView = previousView {
                lastView.snp.makeConstraints { make in
                    make.left.equalTo(containerView.snp.left)
                }
            }
            
            DispatchQueue.main.async {
                let xOffset = self.scrollView.frame.width * CGFloat(6)
                self.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: false)
            }
            
            Task {
                await Factory.shared().stepProgressManager.addSteps(steps: Int(dailySteps.last ?? 0))
                self.scene?.load(date: .now)
            }
        }
    }
    
    public func setScene() {
        self.scene = IsometricScene()
        scene?.scaleMode = .aspectFill
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / scrollView.frame.width)
        if (!index.isNaN) {
            self.pageIndex = index
            self.scene?.load(date: Date().getPastDate(byDays: abs((Int(self.pageIndex) - 6))) ?? Date())
        }
    }
}
