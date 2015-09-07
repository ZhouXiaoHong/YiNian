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
}

class YNTextView: UIView, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    var delegate: YNTextViewDelegate?
    
    override func awakeFromNib() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "presentImagePickerSheet:")
        self.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Text view delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.delegate?.textViewDidReturn(textView, pic: nil)
            return false;
        }
        return true
    }
}
