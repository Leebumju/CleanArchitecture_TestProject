//
//  CompositionalLayoutProvider.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

struct CompositionalLayoutProvider {
    struct ItemLayout {
        let size: NSCollectionLayoutSize
    }
    
    struct GroupLayout {
        let size: NSCollectionLayoutSize
        let contentInsets: NSDirectionalEdgeInsets
        let interItemSpacing: NSCollectionLayoutSpacing?
        
        init(size: NSCollectionLayoutSize,
             contentInsets: NSDirectionalEdgeInsets = .zero,
             interItemSpacing: NSCollectionLayoutSpacing? = nil) {
            self.size = size
            self.contentInsets = contentInsets
            self.interItemSpacing = interItemSpacing
        }
    }
    
    struct SectionLayout {
        let contentInsets: NSDirectionalEdgeInsets
        let interGroupSpacing: CGFloat
        let headerSize: NSCollectionLayoutSize?
        let footerSize: NSCollectionLayoutSize?
        let scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
        let visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?
        let isStickyHeader: Bool
        
        init(contentInsets: NSDirectionalEdgeInsets = .zero,
             interGroupSpacing: CGFloat = 0,
             headerSize: NSCollectionLayoutSize? = nil,
             footerSize: NSCollectionLayoutSize? = nil,
             scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
             visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler? = nil,
             isStickyHeader: Bool = false) {
            self.contentInsets = contentInsets
            self.interGroupSpacing = interGroupSpacing
            self.headerSize = headerSize
            self.footerSize = footerSize
            self.scrollingBehavior = scrollingBehavior
            self.visibleItemsInvalidationHandler = visibleItemsInvalidationHandler
            self.isStickyHeader = isStickyHeader
        }
    }
    
    static func configureLayout(withItemLayout itemLayout: ItemLayout,
                                groupLayout: GroupLayout,
                                sectionLayout: SectionLayout,
                                isVertical: Bool = true) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            return configureSectionLayout(withItemLayout: itemLayout, groupLayout: groupLayout, sectionLayout: sectionLayout, isVertical: isVertical)
        }
    }
    
    static func configureSectionLayout(withItemLayout itemLayout: ItemLayout,
                                       groupLayout: GroupLayout,
                                       sectionLayout: SectionLayout,
                                       isVertical: Bool = true) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: itemLayout.size)
        
        var group: NSCollectionLayoutGroup
        
        if isVertical {
            group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayout.size, subitems: [item])
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayout.size, subitems: [item])
        }
        
        group.contentInsets = groupLayout.contentInsets
        group.interItemSpacing = groupLayout.interItemSpacing
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = sectionLayout.interGroupSpacing
        section.contentInsets = sectionLayout.contentInsets
        section.orthogonalScrollingBehavior = sectionLayout.scrollingBehavior
        section.visibleItemsInvalidationHandler = sectionLayout.visibleItemsInvalidationHandler
        
        if let headerSize = sectionLayout.headerSize {
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            header.pinToVisibleBounds = sectionLayout.isStickyHeader
            section.boundarySupplementaryItems.append(header)
        }
        
        if let footerSize = sectionLayout.footerSize {
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                     elementKind: UICollectionView.elementKindSectionFooter,
                                                                     alignment: .bottom)
            section.boundarySupplementaryItems.append(footer)
        }
        
        return section
    }
}
