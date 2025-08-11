//
//  ViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/7/25.
//

import UIKit
import SpriteKit
import HealthKit
import CoreMotion
import UICountingLabel

class HomeViewController: UIViewController {

    private var scene: IsometricScene?
    private let healthStore = HKHealthStore()
    private let stepGoal: CGFloat = Constants.stepGoal
    private var pageIndex: CGFloat = 0.0
    private var isModalDisplayed: Bool = false
    private var modalQueue: [(() -> ())] = []
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.backgroundColor = UIColor(hex: 0xcc99cc)
        progressView.tintColor = UIColor(hex: 0x800080)
        
        return progressView
    }()
    
    private var todayStepLabel: UICountingLabel?
    private var todayProgressView: CircularProgressGraphView?
    
    private lazy var labelProgressToGo: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 14)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        return scrollView
    }()
    private var labelSteps: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 28)
        label.textColor = .black
        
        return label
    }()
    private lazy var labelStepsGoal: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 14)
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
    
    private lazy var viewNoData: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0.8
        
        return view
    }()
    
    private lazy var labelNoData: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "No Data Available"
        label.textColor = .white
        label.font = FontHelper.getBoldFont(size: 16)
        
        return label
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "left_arrow")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "right_arrow")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        return imageView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(monsterFound), name: .MonsterFound, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(detectedForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.view.backgroundColor = .white
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        self.setup()
        
        if (!Date.now.isSameDay(as: SwiftAppDefaults.shared.lastDailyGiftDate)) {
            self.queueUpNextModal {
                DailyRewardView().displayView(self) {
                    SwiftAppDefaults.shared.lastDailyGiftDate = Date.now
                    self.modalDismissed()
                }
            }
        }
        
        
        if (SwiftAppDefaults.shared.monstersFound.count > 0) {
            for monsterNumber in SwiftAppDefaults.shared.monstersFound {
                self.displayMonsterFound(monsterNumber)
            }
        }
        
        Factory.shared().pedometer.startUpdates(from: Date()) { data, error in
            self.updateSteps(steps: data?.numberOfSteps.intValue ?? 0)
        }
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
        self.view.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(7)
        }
        self.view.addSubview(self.labelProgressToGo)
        self.labelProgressToGo.snp.makeConstraints { make in
            make.top.equalTo(self.progressView.snp.bottom).offset(2)
            make.centerX.equalTo(self.progressView.snp.centerX)
        }
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.labelProgressToGo.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(350)
        }
        
        self.view.addSubview(self.leftImageView)
        self.leftImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.scrollView.snp.centerY)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        self.view.addSubview(self.rightImageView)
        self.rightImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.scrollView.snp.centerY)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        self.view.addSubview(skView)
        skView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.bottom).offset(16)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        self.skView.addSubview(self.viewNoData)
        self.viewNoData.snp.makeConstraints { make in
            make.edges.equalTo(self.skView.snp.edges)
        }
        
        self.viewNoData.addSubview(self.labelNoData)
        self.labelNoData.snp.makeConstraints { make in
            make.center.equalTo(self.skView.snp.center)
        }
        
        self.viewNoData.isHidden = true
        
        //self.authorizeHealthKit()
        self.calculateSteps()
    }
    
    private func authorizeHealthKit() {
        /*
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
         */
    }
    
    
    func calculateSteps() {
        DispatchQueue.main.async {
            self.scrollView.subviews.forEach { $0.removeFromSuperview() }
            self.rightImageView.isHidden = true
            self.leftImageView.isHidden = false
            
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
                    
                    let customStackView = UIStackView(frame: .zero)
                    customStackView.axis = .vertical
                    customStackView.alignment = .center
                    customStackView.spacing = 5
                    
                    print("OFFSET: \(data.offset)")
                    let offset = data.offset - 6
                    let dateLabel = UILabel(frame: .zero)
                    dateLabel.font = FontHelper.getBoldFont(size: 24)
                    dateLabel.textColor = .black
                    dateLabel.text = offset == 0 ? "Today" : Date().getPastDate(byDays: abs(offset))?.formatted(.dateTime.month(.abbreviated).day()) ?? ""
                    
                    customStackView.addArrangedSubview(dateLabel)
                    
                    let titleLabel = UICountingLabel(frame: .zero)
                    titleLabel.font = FontHelper.getBoldFont(size: 28)
                    titleLabel.textColor = .black
                    titleLabel.format = "%d"
                    titleLabel.count(from: 0, to: CGFloat(steps))
                    //titleLabel.text = Int(steps).withCommas()

                    customStackView.addArrangedSubview(titleLabel)
                    
                    let subtitleLabel = UILabel(frame: .zero)
                    subtitleLabel.font = FontHelper.getBoldFont(size: 14)
                    subtitleLabel.textColor = .black
                    subtitleLabel.text = "of \(Int(self.stepGoal).withCommas()) steps"
                    
                    customStackView.addArrangedSubview(subtitleLabel)
                    
                    let progressView = CircularProgressGraphView(customView: customStackView)
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
                    
                    if (dateLabel.text == "Today") {
                        self.todayStepLabel = titleLabel
                        self.todayProgressView = progressView
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
                
                self.updateSteps(steps: Int(dailySteps.last ?? 0), updateProgress: false)
            }
        }
    }
    
    private func updateSteps(steps: Int, updateProgress: Bool = true) {
        Task {
            await Factory.shared().stepProgressManager.addSteps(steps: steps)
            let stepsSoFar = steps % Int(Constants.stepsPerLevelUp)
            UIView.animate(withDuration: 0.2) {
                self.progressView.progress = Float(CGFloat(stepsSoFar) / Constants.stepsPerLevelUp)
            }
            self.labelProgressToGo.text = "Next tile search in \(Int(Constants.stepsPerLevelUp) - stepsSoFar) steps."
            self.scene?.load(date: .now) { hasData in
                self.viewNoData.isHidden = hasData
            }
            
            if (updateProgress) {
                let currentCount = self.todayStepLabel?.currentValue() ?? 0
                let currentSteps = Factory.shared().stepProgressManager.getCurrentSteps()
                self.todayStepLabel?.count(from: currentCount, to: CGFloat(currentSteps), withDuration: 0.3)
                self.todayProgressView?.progress = CGFloat(currentSteps) / self.stepGoal
            }
        }
    }
    
    private func displayMonsterFound(_ monsterNumber: Int) {
        SwiftAppDefaults.removeMonster(monsterNumber)
        DispatchQueue.main.async {
            self.queueUpNextModal {
                MonsterFoundView().displayView(self, monsterNumber: monsterNumber) {
                    self.modalDismissed()
                }
            }
        }
    }
    
    @objc private func monsterFound(notification: Notification) {
        if let monsterNum = notification.object as? Int {
            if (SwiftAppDefaults.shared.monstersFound.contains(monsterNum)) {
                self.displayMonsterFound(monsterNum)
            }
        }
    }
    
    @objc private func detectedForeground(notification: Notification) {
        calculateSteps()
    }
    
    private func modalDismissed() {
        self.isModalDisplayed = false
        self.queueUpNextModal()
    }
    
    private func queueUpNextModal(nextQueue: (() -> ())? = nil) {
        if let nextQueue = nextQueue {
            self.modalQueue.append(nextQueue)
        }
        
        if !self.modalQueue.isEmpty && !self.isModalDisplayed {
            self.isModalDisplayed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.modalQueue[0]()
                self.modalQueue.removeFirst()
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
            self.scene?.load(date: Date().getPastDate(byDays: abs((Int(self.pageIndex) - 6))) ?? Date()) { hasData in
                self.viewNoData.isHidden = hasData
            }
            
            self.leftImageView.isHidden = self.pageIndex <= 0
            self.rightImageView.isHidden = self.pageIndex >= 6
        }
    }
}
