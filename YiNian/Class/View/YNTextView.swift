//
//  YNTextView.swift
//  YiNian
//
//  Created by 周宏 on 15/9/4.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

protocol YNTextViewDelegate {
    func textViewDidReturn(textView: UITextView, pic: UIImage?)
    func textViewDidEnterPic() -> UIImage?
}

class YNTextView: UIView, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var delegate: YNTextViewDelegate?
    
    var iv: UIImageView = {
        let iv = UIImageView()
        iv.hidden = true
        return iv
    }()
    
    var keyboardHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 500, right: 0)
        textView.bounces = false
        self.addSubview(iv)
    }
    // MARK: - Notification selector
    func keyboardWillShow(notification: NSNotification) {
        // 保存键盘高度
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardInfo: AnyObject? = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)
        let height = keyboardInfo?.CGRectValue().size.height
        if let height = height {
            keyboardHeight = height
        }
    }
    
    // MARK: - Text view delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.delegate?.textViewDidReturn(textView, pic: iv.image)
            return false;
        } else if text == "t" {
            if textView.text.hasSuffix("@") {
                textView.text.removeAtIndex(textView.text.endIndex.predecessor())
                textView.endEditing(true)
                self.delegate?.textViewDidEnterPic()
                return false
            }
        } else if text == " " {
            if textView.text .hasSuffix(" ") {
                self.textView.text =  self.textView.text + "\n"
                return false
            }
            return true
        }
        return true
    }
    
    func selectImageView(image: UIImage, frame: CGRect) {
        iv.image = image
        iv.frame = frame
        iv.hidden = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.iv.frame = CGRectMake(100, self.keyboardHeight, 100, 100)
        }) { (hasDone) -> Void in
            if hasDone {
                self.textView.becomeFirstResponder()
            }
        }
    }
}
