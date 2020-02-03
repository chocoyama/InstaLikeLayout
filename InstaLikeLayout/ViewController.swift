//
//  ViewController.swift
//  InstaLikeLayout
//
//  Created by Takuya Yokoyama on 2020/02/03.
//  Copyright © 2020 chocoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var layoutData = Layout.Model((0..<1000).map { Item(name: "\($0)") })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.setCollectionViewLayout(Layout.build(for: layoutData), animated: false)
        self.collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        layoutData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        layoutData.items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = layoutData.items[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        return cell.configured(for: item)
    }
}

struct Item {
    let name: String
    let color = UIColor(red: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                        green: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                        blue: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                        alpha: 1.0)
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @discardableResult
    func configured(for item: Item) -> Self {
        label.text = item.name
        backgroundColor = item.color
        return self
    }
}
