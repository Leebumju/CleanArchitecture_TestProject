//
//  LineTabs.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import UIKit

struct LineTabModel {
    let title: String?
    let tabAction: () -> Void
}

final class LineTabs: UIStackView {
    init(tabList: [LineTabModel]) {
        super.init(frame: .zero)
        
        distribution = .fillEqually
        
        configureView(withTabList: tabList)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(withTabList tabList: [LineTabModel]) {
        for tabModel in tabList {
            let underLineView = UnderLineTouchableView(tabModel.title)
            underLineView.didTapped(onTapped: tabModel.tabAction)
            
            addArrangedSubview(underLineView)
        }
        
        (arrangedSubviews.first as? UnderLineTouchableView)?.didSelect(true)
    }
    
    func selectTab(_ selectedIndex: Int) {
        guard selectedIndex < arrangedSubviews.count else { return }
        
        for (index, subView) in arrangedSubviews.enumerated() {
            (subView as? UnderLineTouchableView)?.didSelect(index == selectedIndex)
        }
    }
}
