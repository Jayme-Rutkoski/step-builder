//
//  MonsterSummaryView.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/13/25.
//

import UIKit
import SnapKit
import Foundation

class MonsterSummaryView: UIView {
    
    private var items: [MonsterSummary] = []
    private var onCompletion: (() -> ())!
    var myViewHeightConstraint: Constraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.layoutIfNeeded()
        print("CollectionView: \(self.collectionView.contentSize.height)")
        self.myViewHeightConstraint?.update(offset: self.collectionView.contentSize.height)
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MonsterSummaryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(hex: 0xa64ca6)
        collectionView.layer.cornerRadius = 20
        
        return collectionView
    }()
    
    private lazy var viewOpacity: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0.8
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontHelper.getBoldFont(size: 20)
        label.text = "Monsters Found While You Were Gone"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var viewTitle: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0x800080)
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var viewBackground: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: 0xcc99cc)
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private lazy var buttonCollect: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Collect", for: .normal)
        button.titleLabel?.font = FontHelper.getBoldFont(size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonCollect_TouchUpInside), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: 0x800080)
        button.layer.cornerRadius = 10
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    private lazy var imageViewMonster: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private func setup(viewController: UIViewController) {
        self.addSubview(self.viewOpacity)
        self.viewOpacity.snp.makeConstraints { make in
            make.edges.equalTo(viewController.view.snp.edges)
        }
        
        self.addSubview(self.viewBackground)
        self.viewBackground.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(viewController.view.safeAreaLayoutGuide).offset(25)
            make.bottom.lessThanOrEqualTo(viewController.view.safeAreaLayoutGuide).inset(25)
            //make.centerX.equalTo(viewController.view.snp.centerX)
            make.centerY.equalTo(viewController.view.safeAreaLayoutGuide)
            make.left.equalTo(viewController.view.snp.left).offset(25)
            make.right.equalTo(viewController.view.snp.right).inset(25)
            make.height.equalTo(0).priority(250)
        }
        
        self.viewBackground.addSubview(self.viewTitle)
        self.viewTitle.snp.makeConstraints { make in
            make.top.equalTo(self.viewBackground.snp.top).offset(20)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.left.equalTo(viewBackground.snp.left).offset(10)
            make.right.equalTo(viewBackground.snp.right).inset(10)
            make.height.equalTo(60)
        }
        
        self.viewTitle.addSubview(self.labelTitle)
        self.labelTitle.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.top).offset(5)
            make.bottom.equalTo(self.viewTitle.snp.bottom).offset(-5)
            make.left.equalTo(self.viewTitle.snp.left).offset(12)
            make.right.equalTo(self.viewTitle.snp.right).offset(-12)
        }

        self.viewBackground.addSubview(self.buttonCollect)
        self.buttonCollect.snp.makeConstraints { make in
            make.bottom.equalTo(self.viewBackground.snp.bottom).offset(-20)
            make.centerX.equalTo(self.viewBackground.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(70)
        }
        
        self.viewBackground.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.viewTitle.snp.bottom).offset(20)
            make.left.equalTo(self.viewBackground.snp.left).offset(20)
            make.right.equalTo(self.viewBackground.snp.right).offset(-20)
            make.bottom.equalTo(self.buttonCollect.snp.top).offset(-20)
            self.myViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    private func displayOnViewController(_ viewController: UIViewController) {
        print("MONSTERS FOUND: \(SwiftAppDefaults.shared.monstersFound)")
        let filteredMonsters = Factory.shared().monsters.filter { SwiftAppDefaults.shared.monstersFound.contains($0.id) }
        let monsterCounts = Dictionary(grouping: filteredMonsters, by: { $0.id })
        let monsterSummaries = filteredMonsters.map { MonsterSummary.init(monster: $0, quantity: monsterCounts[$0.id]?.count ?? 0, isNew: true)}
        self.items = monsterSummaries
        viewController.view.addSubview(self)
        self.snp.makeConstraints { make in
            make.centerY.equalTo(viewController.view.snp.centerY)
            make.centerX.equalTo(viewController.view.snp.centerX)
        }
        self.setup(viewController: viewController)
        self.collectionView.reloadData()
        viewController.view.layoutIfNeeded()
        viewController.view.bringSubviewToFront(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 1.0
        })
    }
    
    @objc private func buttonCollect_TouchUpInside() {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.opacity = 0.0
        }) { _ in
            self.removeFromSuperview()
            self.onCompletion()
        }
        
        NotificationCenter.default.post(name: .CurrencyUpdate, object: 5)
    }
    
    public func displayView(_ viewController: UIViewController, onCompletion: @escaping (() -> ())) {
        self.layer.opacity = 0.0
        self.onCompletion = onCompletion
        self.displayOnViewController(viewController)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}

extension MonsterSummaryView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("ITEMS: \(self.items.count)")
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonsterSummaryCollectionViewCell
        
        let item = self.items[indexPath.row]
        cell.configure(with: item.monster.id, name: item.monster.name, quantity: item.quantity, isNew: true)
        
        return cell
    }
}
extension MonsterSummaryView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = 75.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
    }
}
