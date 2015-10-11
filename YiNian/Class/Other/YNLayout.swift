//
//  YNLayout.swift
//  YiNian
//
//  Created by 周宏 on 15/10/1.
//  Copyright © 2015年 Mars. All rights reserved.
//

import UIKit

class YNLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        scrollDirection = .Horizontal
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCCenter = proposedContentOffset.x + collectionView!.bounds.size.width / 2
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        let array = super.layoutAttributesForElementsInRect(targetRect)!
        
        for layoutAttributes in array {
            let itemHorizontalCenter = layoutAttributes.center.x
            if abs(itemHorizontalCenter - horizontalCCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCCenter
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
