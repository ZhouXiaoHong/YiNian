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
        itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
//        minimumInteritemSpacing = 200
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
    
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let array = super.layoutAttributesForElementsInRect(rect)
//        let visibleRect = CGRect(origin: (self.collectionView?.contentOffset)!, size: (self.collectionView?.bounds.size)!)
//        
//        for attributes in array! {
//            if CGRectIntersectsRect(attributes.frame, rect) {
//                let distance = CGRectGetMidX(visibleRect) - attributes.center.x
//                let normalizedDistance = distance / 200
//                if abs(distance) < 200 {
//                    let zoom = 1 + 1 * (1 - abs(normalizedDistance))
//                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
//                    attributes.zIndex = 1
//                }
//            }
//        }
//        return array
//    }
}
