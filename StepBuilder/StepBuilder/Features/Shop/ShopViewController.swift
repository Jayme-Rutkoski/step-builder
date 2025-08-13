//
//  ShopViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/8/25.
//

import Foundation
import UIKit

class ShopViewController: UIViewController {
    
    private var items: [ShopItem] = []
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: 0xe4d2ba)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "bag")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(inventoryTapped))
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Shop"
    }
    
    func setup() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        self.populateList()
    }
    
    func populateList() {
        self.items = Factory.shared().shopItems
        self.collectionView.reloadData()
    }
    
    @objc private func inventoryTapped() {
        InventoryCoordinator.init(viewController: self).start()
    }
}

extension ShopViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShopCollectionViewCell
        
        let item = self.items[indexPath.row]
        cell.configure(with: item.itemNumber, name: item.name, price: item.price)
        
        return cell
    }
}
extension ShopViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 10) / CGFloat(2)
        let height = 250.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        ShopBuyView().displayView(self, itemNumber: item.itemNumber, name: item.name, price: item.price) {
            
        }
    }
}
