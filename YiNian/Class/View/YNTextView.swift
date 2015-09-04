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
    weak var delegate: YNTextViewDelegate?
    
    override func awakeFromNib() {
        textView.layer.borderColor = UIColor.blackColor().CGColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
    }
    
    // MARK: - Text view delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false;
        }
        return true
    }
}
