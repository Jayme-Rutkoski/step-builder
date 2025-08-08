//
//  AwardsViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/7/25.
//

import Foundation
import UIKit

class AwardsViewController: UIViewController {
    
    private var items: [Award] = []
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AwardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Awards"
    }
    
    func setup() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(10)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.bottom.equalTo(self.view.snp.bottom).offset(-10)
        }
        
        self.populateList()
    }
    
    func populateList() {
        self.items = [
            Award(name: "Monsters Found", completionTimes: SwiftAppDefaults.shared.monsterFindCount, image: UIImage(named: "award_monsters_found"), isCompleted: SwiftAppDefaults.shared.monsterFindCount > 0),
            Award(name: "Unique Monsters Found", completionTimes: SwiftAppDefaults.shared.uniqueMonsterFindCount, image: UIImage(named: "award_unique_monsters_found"), isCompleted: SwiftAppDefaults.shared.uniqueMonsterFindCount > 0),
            Award(name: "Total Steps Taken", completionTimes: SwiftAppDefaults.shared.totalStepsTaken, image: UIImage(named: "award_total_steps"), isCompleted: SwiftAppDefaults.shared.totalStepsTaken > 0),
            Award(name: "Login Streak", completionTimes: SwiftAppDefaults.shared.loginStreakCount, image: UIImage(named: "award_login_streak"), isCompleted: true),
            Award(name: "7 Day Login Streak", progress: CGFloat(CGFloat(SwiftAppDefaults.shared.loginStreakCount) / 7), image: UIImage(named: "award_7_login_streak"), isCompleted: SwiftAppDefaults.shared.has7DayLoginStreak),
            Award(name: "14 Day Login Streak", progress: CGFloat(CGFloat(SwiftAppDefaults.shared.loginStreakCount) / 14), image: UIImage(named: "award_14_login_streak"), isCompleted: SwiftAppDefaults.shared.has14DayLoginStreak),
            Award(name: "30 Day Login Streak", progress: CGFloat(CGFloat(SwiftAppDefaults.shared.loginStreakCount) / 30), image: UIImage(named: "award_30_login_streak"), isCompleted: SwiftAppDefaults.shared.has30DayLoginStreak),
            Award(name: "Perfect Day", progress: CGFloat(CGFloat(SwiftAppDefaults.shared.perfectStreakCount) / 1), image: UIImage(named: "award_perfect_day"), isCompleted: SwiftAppDefaults.shared.hasPerfectDay),
            Award(name: "Perfect Week", progress: CGFloat(CGFloat(SwiftAppDefaults.shared.perfectStreakCount) / 7), image: UIImage(named: "award_perfect_week"), isCompleted: SwiftAppDefaults.shared.hasPerfectWeek),
            Award(name: "Perfect Month", progress: CGFloat(CGFloat(SwiftAppDefaults.shared.perfectStreakCount) / 30), image: UIImage(named: "award_perfect_month"), isCompleted: SwiftAppDefaults.shared.hasPerfectMonth),
        ]
        self.collectionView.reloadData()
    }
}

extension AwardsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AwardCollectionViewCell
        
        let item = self.items[indexPath.row]
        cell.configure(with: item.name, image: item.image, completionTimes: item.completionTimes, progress: item.progress, isCompleted: item.isCompleted)
        
        return cell
    }
}
extension AwardsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 10) / CGFloat(2)
        let height = 130.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]

    }
}
