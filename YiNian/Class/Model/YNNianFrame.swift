//
//  YNNianFrame.swift
//  YiNian
//
//  Created by 宏周 on 15/9/3.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class YNNianFrame {
 /// 模型
    let nian: YNNian
 /// 顺序
    var index: Int
    
    var textF: CGRect
    var dateF: CGRect
    var picF: CGRect?
    var height: CGFloat
    
    init(nian: YNNian, index: Int) {
        self.nian = nian
        self.index = index
        
        let maxWidth = (UIScreen.mainScreen().bounds.size.width / 2) - 20
        
        var attribute = NSMutableDictionary()
        attribute.setObject(UIFont.systemFontOfSize(14), forKey: NSFontAttributeName)
        let textS = nian.text.boundingRectWithSize(CGSize(width: maxWidth, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attribute as [NSObject : AnyObject], context: nil).size
        
        let dateS = nian.strDate.boundingRectWithSize(CGSize(width: maxWidth, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attribute as [NSObject : AnyObject], context: nil).size
        
        if index % 2 == 0 {
            textF = CGRect(x: maxWidth - textS.width, y: 0, width: textS.width, height: textS.height)
            dateF = CGRect(x: maxWidth + 10, y: 0, width: dateS.width, height: dateS.height)
            if let pic = nian.pic {
                let img = UIImage(named: "haha")!
                picF = CGRect(x: maxWidth - 80, y: CGRectGetMaxY(textF) + 8, width: 80, height: 80)
            }
        } else {
            textF = CGRect(x: maxWidth + 10, y: 0, width: textS.width, height: textS.height)
            dateF = CGRect(x: maxWidth - dateS.width, y: 0, width: dateS.width, height: dateS.height)
            if let pic = nian.pic {
                let img = UIImage(named: "haha")!
                picF = CGRect(x: maxWidth + 10, y: CGRectGetMaxY(textF) + 8, width: 80, height: 80)
            }
        }
        
        if nian.pic != nil {
            height = CGRectGetMaxY(picF!)
        } else {
            height = CGRectGetMaxY(textF)
        }
    }
}
