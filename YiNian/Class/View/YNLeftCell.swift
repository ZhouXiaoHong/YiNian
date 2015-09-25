//
//  YNLeftCell.swift
//  YiNian
//
//  Created by 宏周 on 15/9/24.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class YNLeftCell: UITableViewCell {
    
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var labelContent: UILabel!

    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var ivBottom: NSLayoutConstraint!
    
    var nian: YNNian? {
        get {
            return self.nian
        }
        set {
            if let nian = newValue {
                labelContent.text = nian.text
                labelTime.text = nian.strDate
                if let pic = nian.pic {
                    iv.backgroundColor = UIColor.redColor()
//                    let data = NSData(contentsOfFile: pic)
//                    let image = UIImage(data: data!)
//                    iv.image = image
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
