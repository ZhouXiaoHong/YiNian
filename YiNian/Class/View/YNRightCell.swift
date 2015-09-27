//
//  YNRightCell.swift
//  YiNian
//
//  Created by 周宏 on 15/9/26.
//  Copyright © 2015年 Mars. All rights reserved.
//

import UIKit

class YNRightCell: UITableViewCell {
    
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var ivBottom: NSLayoutConstraint!
    
    @IBOutlet weak var ivWidth: NSLayoutConstraint!
    
    var nian: YNNian? {
        get {
            return self.nian
        }
        set {
            if let nian = newValue {
                labelContent.text = nian.text
                labelTime.text = nian.strDate
                iv.backgroundColor = UIColor.redColor()
                if let pic = nian.pic {
                    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(pic)
                    
                    iv.backgroundColor = UIColor.redColor()
                    let data = NSData(contentsOfURL: path)
                    if let data = data {
                        iv.hidden = false
                        ivBottom.constant = 10
                        ivWidth.constant = 150
                        let image = UIImage(data: data)
                        iv.image = image
                    } else {
                        iv.hidden = true
                        ivWidth.constant = 0.0
                        ivBottom.constant = 0
                    }
                } else {
                    iv.hidden = true
                    ivWidth.constant = 0.0
                    ivBottom.constant = 0.0
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
