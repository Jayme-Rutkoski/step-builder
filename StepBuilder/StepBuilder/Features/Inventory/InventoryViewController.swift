//
//  InventoryViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//

import Foundation
import UIKit
import SnapKit

class InventoryViewController: UIViewController {
    
    private var items: [InventoryItem] = []
    var myViewHeightConstraint: Constraint?
    
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
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InventoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        return collectionView
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemConsumed), name: .ItemConsumed, object: nil)
        
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
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        self.viewContainer.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.buttonClose.snp.bottom).offset(5)
            make.left.equalTo(self.viewContainer.snp.left)
            make.right.equalTo(self.viewContainer.snp.right)
            make.bottom.equalTo(self.viewContainer.snp.bottom).offset(-10)
        }
        
        self.populateList()
    }
    
    func populateList() {
        self.items = []
        let itemInventory = SwiftAppDefaults.shared.itemInventory.sorted()
        let inventoryGroup = Dictionary(grouping: itemInventory) { $0 }
        
        for (key, value) in inventoryGroup {
            let item = Factory.shared().shopItems.filter { $0.itemNumber == key }.first!
            
            self.items.append(InventoryItem(name: item.name, price: item.price, itemNumber: key, desc: item.desc, quantity: value.count))
        }
        
        self.items.sort { $0.itemNumber < $1.itemNumber }
        self.collectionView.reloadData()
    }
    
    @objc private func buttonClose_TouchUpInside() {
        self.dismiss(animated: true)
    }
    
    @objc private func itemConsumed(notification: Notification) {
        if let itemNum = notification.object as? Int {
            if let index = self.items.firstIndex(where: { $0.itemNumber == itemNum }) {
                let item = self.items[index]
                if (item.quantity == 1) {
                    self.items.remove(at: index)
                } else {
                    item.quantity -= 1
                }
                self.collectionView.reloadData()
            }
        }
    }
}

extension InventoryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InventoryCollectionViewCell
        
        let item = self.items[indexPath.row]
        cell.configure(with: item.itemNumber, quantity: item.quantity)
        
        return cell
    }
}
extension InventoryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 60
        let height = 60
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        InventoryDetailView().displayView(self, itemNumber: item.itemNumber, name: item.name, desc: item.desc) {
            
        }
    }
}
