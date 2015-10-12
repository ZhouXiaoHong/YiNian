//
//  YNCollectionViewCell.swift
//  YiNian
//
//  Created by 周宏 on 15/10/2.
//  Copyright © 2015年 Mars. All rights reserved.
//

import UIKit

class YNCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    
    var nian: YNNian? {
        set {
            if let nian = newValue {
                self.contentLabel.text = nian.text
                self.timeLabel.text = nian.strDate
                if let pic = nian.pic {
                    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(pic)
                    let data = NSData(contentsOfURL: path)
                    if let data = data {                        
                        self.iv.image = UIImage(data: data)
                    }
                }
            }
        }
        
        get {
            return self.nian
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
