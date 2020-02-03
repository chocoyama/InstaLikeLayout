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
            case .leadingLarge: return 3
            case .spread: return 6
            case .trailingLarge: return 3
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
            var layoutKind: Kind = .leadingLarge
            var tmpItems: [Item] = []
            
            for item in items {
                if tmpItems.count == layoutKind.numberOfItem {
                    self.sections.append(layoutKind)
                    self.items.append(tmpItems)
                    layoutKind = layoutKind.next
                    tmpItems = []
                    
                }
                tmpItems.append(item)
            }
            
            self.sections.append(layoutKind)
            self.items.append(tmpItems)
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
                                                   heightDimension: .fractionalHeight(0.4)),
                subitems: nestedGroupItems
            )
            return NSCollectionLayoutSection(group: nestedGroup)
        }
    }
}
