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
            self.collectionView.setCollectionViewLayout(Layout.build(for: sections), animated: false)
            self.collectionView.dataSource = dataSource
        }
    }
    
    typealias Section = Layout.Section<UIColor>
    typealias Item = UIColor
    
    private let sections: [Section] = {
        let colors = (0..<1000).map { _ in
            UIColor(red: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                    green: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                    blue: (CGFloat(arc4random_uniform(255)) + 1) / 255,
                    alpha: 1.0)
        }
        return Layout.Section.build(colors, with: RegularOrderLayoutStrategy())
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, color) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as! CollectionViewCell
        cell.set(title: "\(indexPath.section)-\(indexPath.item)", color: color)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @discardableResult
    func set(title: String, color: UIColor) -> Self {
        label.text = title
        backgroundColor = color
        return self
    }
}
