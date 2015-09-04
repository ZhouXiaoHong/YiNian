//
//  YNTimeView.swift
//  YiNian
//
//  Created by 宏周 on 15/9/4.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class YNTimeView: UIView {
    
    var timer: NSTimer?
    
    @IBOutlet weak var timeLabel: UILabel!
    lazy var formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    override func awakeFromNib() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.timer = timer
        timer.fire()
    }
    
    func updateTime() {
        timeLabel.text = formatter.stringFromDate(NSDate())
    }

}
