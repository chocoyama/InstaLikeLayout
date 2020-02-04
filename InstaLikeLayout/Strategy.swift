//
//  Strategy.swift
//  InstaLikeLayout
//
//  Created by Takuya Yokoyama on 2020/02/05.
//  Copyright © 2020 chocoyama. All rights reserved.
//

import Foundation

protocol LayoutStrategy {
    func buildSections<Item>(for items: [Item]) -> [Layout.Section<Item>]
}

/// Layout.Kindで定義されている1セクションに表示するセルの数ごとに分割していく
struct RegularOrderLayoutStrategy: LayoutStrategy {
    func buildSections<Item>(for items: [Item]) -> [Layout.Section<Item>] {
        var sections = [Layout.Section<Item>]()
        
        var kind: Layout.Kind = .leadingLarge
        var tmpItems: [Item] = []
        for item in items {
            if tmpItems.count == kind.numberOfItemsInSection {
                sections.append(.init(kind: kind, items: tmpItems))
                kind = next(from: kind)
                tmpItems = []
            }
            tmpItems.append(item)
        }
        sections.append(.init(kind: kind, items: tmpItems))
        
        return sections
    }
    
    private func next(from kind: Layout.Kind) -> Layout.Kind {
        // 定義されている次の値を返却する
        Layout.Kind(rawValue: kind.rawValue + 1 == Layout.Kind.allCases.count ? 0 : kind.rawValue + 1)!
    }
}
