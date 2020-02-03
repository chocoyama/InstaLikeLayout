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
        case leadingLarge, spread, trailingLarge
        
        var numberOfItem: Int {
            switch self {
            case .leadingLarge, .trailingLarge: return 3
            case .spread: return 6
            }
        }
        
        var next: Self {
            switch self {
            case .leadingLarge: return .spread
            case .spread: return .trailingLarge
            case .trailingLarge: return .leadingLarge
            }
        }
    }
    
    struct Model<Item> {
        var sections: [Kind] = []
        var items: [[Item]] = []
        
        init(_ items: [Item]) {
            var kind: Kind = .leadingLarge
            var tmpItems: [Item] = []
            
            for item in items {
                if tmpItems.count == kind.numberOfItem {
                    commit(kind, tmpItems)
                    kind = kind.next
                    tmpItems = []
                }
                tmpItems.append(item)
            }
            commit(kind, tmpItems)
        }
        
        private mutating func commit(_ kind: Kind, _ items: [Item]) {
            self.sections.append(kind)
            self.items.append(items)
        }
    }
    
    static func build<Item>(for model: Model<Item>) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let largeItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1/3))
                ),
                count: 2
            )

            let nestedGroupItems: [NSCollectionLayoutItem]
            switch model.sections[sectionIndex] {
            case .leadingLarge: nestedGroupItems = [largeItem, smallGroup]
            case .spread: nestedGroupItems = [spreadGroup, spreadGroup, spreadGroup]
            case .trailingLarge: nestedGroupItems = [smallGroup, largeItem]
            }
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.4)), // CollectionViewの高さの4/10
                subitems: nestedGroupItems
            )
            return NSCollectionLayoutSection(group: nestedGroup)
        }
    }
}
