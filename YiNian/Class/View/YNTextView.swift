//
//  YNTextView.swift
//  YiNian
//
//  Created by 周宏 on 15/9/4.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

protocol YNTextViewDelegate {
    func textViewDidReturn()
}

class YNTextView: UIView, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    var delegate: YNTextViewDelegate?
    
    override func awakeFromNib() {
        textView.layer.borderColor = UIColor.blackColor().CGColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
//        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
    }
    
    // MARK: - Text view delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.delegate?.textViewDidReturn()
            return false;
        }
        return true
    }
}
