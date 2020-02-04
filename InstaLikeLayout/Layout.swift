//
//  Layout.swift
//  InstaLikeLayout
//
//  Created by Takuya Yokoyama on 2020/02/03.
//  Copyright © 2020 chocoyama. All rights reserved.
//

import UIKit

struct Layout {
    enum Kind: Int, CaseIterable {
        case leadingLarge, spread1, trailingLarge, spread2
        
        var numberOfItemsInSection: Int {
            switch self {
            case .leadingLarge, .trailingLarge: return 3
            case .spread1, .spread2: return 6
            }
        }
    }
    
    struct Section<Item: Hashable>: Hashable {
        let id = UUID()
        let kind: Kind
        let items: [Item]
        
        static func build(_ items: [Item], with strategy: LayoutStrategy) -> [Section<Item>] {
            strategy.buildSections(for: items)
        }
    }
    
    /// GroupはItemをまとめるもので、初期化時にGroup自体のレイアウトサイズを決定する
    /// Item内で指定するLayoutSizeはこのGroupのレイアウトサイズを基準に決定されることになる
    /// Groupのネストをする場合は、親のGroupのレイアウトサイズが基準になり、それをベースに子Group, Itemのレイアウトサイズが決定されていく
    static func build<Item>(for sections: [Section<Item>]) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let largeItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), // 幅：CollectionViewの幅の2/3
                                                   heightDimension: .fractionalHeight(1.0)) // 高さ：CollectionViewの高さに合わせる
            )
            
            let smallGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), // 幅：CollectionViewの幅の1/3
                                                   heightDimension: .fractionalHeight(1.0)), // 高さ：CollectionViewの高さに合わせる
                subitem: NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), // 幅：Groupの幅のに合わせる
                                                       heightDimension: .fractionalHeight(1.0)) // 高さ: Groupの高さをcountで割った値にする
                ),
                count: 2
            )
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), // CollectionViewの幅に合わせる
                                                   heightDimension: .fractionalHeight(0.4)), // CollectionViewの高さの4/10
                subitems: {
                    switch sections[sectionIndex].kind {
                    case .leadingLarge: return [largeItem, smallGroup]
                    case .spread1, .spread2: return [smallGroup, smallGroup, smallGroup]
                    case .trailingLarge: return [smallGroup, largeItem]
                    }
                }()
            )
            return NSCollectionLayoutSection(group: nestedGroup)
        }
    }
}
