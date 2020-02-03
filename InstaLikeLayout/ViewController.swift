//
//  ViewController.swift
//  InstaLikeLayout
//
//  Created by Takuya Yokoyama on 2020/02/03.
//  Copyright © 2020 chocoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.setCollectionViewLayout(layout, animated: false)
            self.collectionView.dataSource = self
        }
    }
    
    private enum LayoutKind: Int, CaseIterable {
        case leadingLarge, spread, trailingLarge
        
        var numberOfItem: Int {
            switch self {
            case .leadingLarge: return 3
            case .spread: return 6
            case .trailingLarge: return 3
            }
        }
    }
    
    private let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        let largeItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                               heightDimension: .fractionalHeight(1.0))
        )
        
        let spreadGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalHeight(1.0)),
            subitem: NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1/3))
            ),
            count: 2
        )

        let smallGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                               heightDimension: .fractionalHeight(1.0)),
            subitem: NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.3))
            ),
            count: 2
        )

        let nestedGroupItems: [NSCollectionLayoutItem]
        switch LayoutKind(rawValue: sectionIndex % 3)! {
        case .leadingLarge: nestedGroupItems = [largeItem, smallGroup]
        case .spread: nestedGroupItems = [spreadGroup, spreadGroup, spreadGroup]
        case .trailingLarge: nestedGroupItems = [smallGroup, largeItem]
        }
        
        let nestedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.4)),
            subitems: nestedGroupItems
        )
        return NSCollectionLayoutSection(group: nestedGroup)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        LayoutKind(rawValue: section % 3)!.numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
    }
}

class CollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .random
    }
}

extension UIColor {
    static var random: UIColor {
        UIColor(red: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                green: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                blue: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                alpha: 1.0)
    }
}
