//
//  YNTimeCell.swift
//  YiNian
//
//  Created by 宏周 on 15/9/7.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class YNTimeCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var timer: NSTimer?
    
    lazy var formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
        }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 设置时间
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.timer = timer
        timer.fire()
    }
    
    func updateTime() {
        label.text = formatter.stringFromDate(NSDate())
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
