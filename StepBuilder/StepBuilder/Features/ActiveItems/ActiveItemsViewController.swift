//
//  ActiveItemsViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 10/27/25.
//

import Foundation
import UIKit
import SnapKit

class ActiveItemsViewController: UIViewController {
    
    private var items: [ActiveItem] = []
    var myViewHeightConstraint: Constraint?
    private let desiredTile: CGFloat = 60
    
    private var viewOpacity: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.layer.opacity = 0.6
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private var viewContainer: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hex: 0xcc99cc)
        
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ActiveItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var buttonClose: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonClose_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .init(white: 0.0, alpha: 0.6)
                
        self.setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.layoutIfNeeded()
        self.myViewHeightConstraint?.update(offset: self.collectionView.contentSize.height + 50)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Shop"
    }
    
    func setup() {
        self.view.addSubview(self.viewOpacity)
        self.viewOpacity.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        self.view.addSubview(self.viewContainer)
        self.viewContainer.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY)
            make.left.equalTo(self.view.snp.left).offset(50)
            make.right.equalTo(self.view.snp.right).inset(50)
            self.myViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        self.viewContainer.addSubview(self.buttonClose)
        self.buttonClose.snp.makeConstraints { make in
            make.top.equalTo(self.viewContainer.snp.top).offset(10)
            make.right.equalTo(self.viewContainer.snp.right).offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        self.viewContainer.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.buttonClose.snp.bottom).offset(5)
            make.left.equalTo(self.viewContainer.snp.left).offset(10)
            make.right.equalTo(self.viewContainer.snp.right).offset(-10)
            make.bottom.equalTo(self.viewContainer.snp.bottom).offset(-10)
        }
        
        self.populateList()
    }
    
    func populateList() {
        self.items = []
        
        if (SwiftAppDefaults.shared.hasMonsterBaitActive) {
            items.append(ActiveItem(itemNumber: 10001, name: "Monster Bait Active"))
        }
        
        if (SwiftAppDefaults.shared.hasLuckyCharmActive) {
            items.append(ActiveItem(itemNumber: 10003, name: "Lucky Charm Active"))
        }

        self.collectionView.reloadData()
    }
    
    @objc private func buttonClose_TouchUpInside() {
        self.dismiss(animated: true)
    }
}

extension ActiveItemsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActiveItemCollectionViewCell

        let item = self.items[indexPath.row]
        cell.configure(with: item.itemNumber, name: item.name)
        return cell
    }
}
extension ActiveItemsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
       
        return CGSize(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
    }
}
