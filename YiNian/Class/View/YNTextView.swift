//
//  YNTextView.swift
//  YiNian
//
//  Created by 周宏 on 15/9/4.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

protocol YNTextViewDelegate {
    func textViewDidReturn(textView: UITextView, pic: String?)
    func textViewDidEnterPic() -> UIImage?
}

class YNTextView: UIView, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    var delegate: YNTextViewDelegate?
    
    override func awakeFromNib() {
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0)
        textView.bounces = false
    }
    
    // MARK: - Text view delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.delegate?.textViewDidReturn(textView, pic: nil)
            return false;
        } else if text == "t" {
//            if textView.text.hasSuffix("#") {
                self.delegate?.textViewDidEnterPic()
//            }
        } else if text == " " {
            if textView.text .hasSuffix(" ") {
                self.textView.text =  self.textView.text + "\n"
                return false
            }
            return true
        }
        return true
    }
}
