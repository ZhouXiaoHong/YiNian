//
//  YNCollectionViewCell.swift
//  YiNian
//
//  Created by 周宏 on 15/10/2.
//  Copyright © 2015年 Mars. All rights reserved.
//

import UIKit

protocol YNCollectionViewCellDelegate {
    func collectionViewCellDidDoubleClick()
}

class YNCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var consLabelTopToCell: NSLayoutConstraint!
    
    @IBOutlet weak var consLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var consIvHeight: NSLayoutConstraint!
    
    var delegate: YNCollectionViewCellDelegate?
    
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
                        self.iv.hidden = false
                        self.consIvHeight.active = true
                        self.consLabelTopToCell.active = false
                        self.layoutIfNeeded()
                    } else {
                        self.iv.hidden = true
                        self.consIvHeight.active = false
                        self.consLabelTopToCell.active = true
                        self.layoutIfNeeded()
                    }
                } else {
                    self.iv.hidden = true
                    self.consIvHeight.active = false
                    self.consLabelTopToCell.active = true
                    self.layoutIfNeeded()
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
