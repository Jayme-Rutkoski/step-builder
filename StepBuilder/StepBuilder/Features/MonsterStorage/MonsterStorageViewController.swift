//
//  MonsterStorageViewController.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 4/1/2026.
//

import Foundation
import UIKit

class MonsterStorageViewController: UIViewController {
    
    private var items: [Monster] = []
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MonsterStorageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: 0xe4d2ba)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Monsters"
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
        self.items = MonsterCollectionHelper.loadAllMonsters()
        self.collectionView.reloadData()
    }
}

extension MonsterStorageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonsterStorageCollectionViewCell
        
        let item = self.items[indexPath.row]
        cell.configure(with: item.id, currentLevel: item.currentLevel ?? 1)
        
        return cell
    }
}
extension MonsterStorageViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 80.0
        let height = 80.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        
        MonsterStorageDetailsView().displayView(self, monster: item) {
            
        }
    }
}
