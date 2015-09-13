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
    
    let motto = "我上班就是为了钱，可他非要和我谈理想，可我的理想是不上班"
    
    @IBOutlet weak var textView: UITextView!
    
    let placeholder = UILabel()
    
    var delegate: YNTextViewDelegate?
    
    var iv: UIImageView = {
        let iv = UIImageView()
        iv.hidden = true
        return iv
    }()
    
    var keyboardHeight: CGFloat = 0.0
    
    // 初始化
    override func awakeFromNib() {
        // 监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // textView
        textView.bounces = false
        textView.selectedRange = NSMakeRange(0, 0)
        self.addSubview(iv)
        
        // setup占位文字
        placeholder.userInteractionEnabled = false
        placeholder.font = textView.font
        placeholder.text = motto
        placeholder.frame = CGRectMake(6, 8, UIScreen.mainScreen().bounds.size.width - 6, 50)
        placeholder.textColor = UIColor.whiteColor()
        placeholder.numberOfLines = 0
        placeholder.sizeToFit()
        self.addSubview(placeholder)
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
    
    // MARK: - Notification selector
    func keyboardWillChange(notification: NSNotification) {
        // 保存键盘高度
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardInfo: AnyObject? = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
        let height = keyboardInfo?.CGRectValue().size.height
        if let height = height {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        }
    }
    
    // MARK: - Text view delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // 是否为回车
            textView.text = ""
            textView.resignFirstResponder()
            self.delegate?.textViewDidReturn(textView, pic: iv.image)
            return false;
        } else if text == "@" {
            // 是否为@
            textView.endEditing(true)
            self.delegate?.textViewDidEnterPic()
            return false
        } else if text == " " {
            // 是否为空格
            if textView.text .hasSuffix(" ") {
                self.textView.text =  self.textView.text + "\n"
                return false
            }
            return true
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if count(textView.text) == 0 {
            placeholder.hidden = false
        } else {
            placeholder.hidden = true
        }
    }
}
