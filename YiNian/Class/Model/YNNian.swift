//
//  YNNian.swift
//  YiNian
//
//  Created by 宏周 on 15/9/2.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class YNNian {
    var date: NSDate
    var text: String
    var pic: String?
    var strDate: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMddHHmm"
        return formatter.stringFromDate(date)
    }
    
    init(date: NSDate, text: String, pic: String?) {
        self.date = date
        self.text = text
        self.pic = pic
    }
}
