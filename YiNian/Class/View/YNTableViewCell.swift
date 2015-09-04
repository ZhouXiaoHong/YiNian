//
//  YNTableViewCell.swift
//  YiNian
//
//  Created by 宏周 on 15/9/3.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class YNTableViewCell: UITableViewCell {
    
    var contentLabel: UILabel
    var timeLabel: UILabel
    var pic: UIImageView
    var nianF: YNNianFrame? {
        get{
            return self.nianF
        }
        
        set {
            self.contentLabel.text = newValue!.nian.text
            self.contentLabel.frame = newValue!.textF
            self.timeLabel.text = newValue!.nian.strDate
            self.timeLabel.frame = newValue!.dateF
            if let pic = newValue!.nian.pic {
                self.imageView!.image = UIImage(named: "haha")!
                self.imageView!.frame = newValue!.picF!
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFontOfSize(14)
        contentLabel.numberOfLines = 0
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFontOfSize(14)
        
        pic = UIImageView()
        pic.contentMode = UIViewContentMode.ScaleAspectFit
        pic.clipsToBounds = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(contentLabel)
        self.addSubview(timeLabel)
        self.addSubview(pic)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("这个方法是傻逼的")
    }
}
