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
    
    let motto = "唯有孤獨是永恆的"
    
    @IBOutlet weak var textView: UITextView!
    
    let placeholder = UILabel()
    
    var delegate: YNTextViewDelegate?
    
    var btn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        btn.hidden = true
        return btn
    }()
    
    var keyboardHeight: CGFloat = 0.0
    
    // 初始化
    override func awakeFromNib() {
        // 监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // textView
        textView.bounces = false
        textView.selectedRange = NSMakeRange(0, 0)
        
        // 图片
        btn.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btn)
        
        // setup占位文字
        placeholder.userInteractionEnabled = false
        placeholder.font = textView.font
        placeholder.text = motto
        placeholder.frame = CGRectMake(6, 8, UIScreen.mainScreen().bounds.size.width - 6, 50)
        placeholder.textColor = UIColor(white: 72/255.0, alpha: 1.0)
        placeholder.numberOfLines = 0
        placeholder.sizeToFit()
        self.addSubview(placeholder)
    }
    
    func btnClick(sender: UIButton) {
        sender.hidden = true
        sender.setImage(nil, forState: .Normal)
    }
    
    func selectImageView(image: UIImage, frame: CGRect) {
        btn.imageView?.image = image
        btn.setImage(image, forState: UIControlState.Normal)
        btn.frame = frame
        btn.hidden = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            let frame = UIScreen.mainScreen().bounds
            self.btn.frame = CGRectMake(frame.width - 100 - 10, frame.height - self.keyboardHeight - 10 - 100, 100, 100)
            }) { (hasDone) -> Void in
                if hasDone {
//                    self.textView.becomeFirstResponder()
                }
        }
    }
    
    // MARK: - Notification selector
    func keyboardWillChange(notification: NSNotification) {
        // 保存键盘高度
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardInfo: AnyObject? = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
        let height = keyboardInfo?.CGRectValue.size.height
        if let height = height {
            if !btn.hidden {
                btn.frame.origin.y += keyboardHeight - height
            }
            keyboardHeight = height
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        }
    }
    
    // MARK: - Text view delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // 是否为回车
            textView.resignFirstResponder()
            self.delegate?.textViewDidReturn(textView, pic: btn.imageView!.image)
            btn.setImage(nil, forState: UIControlState.Normal)
            textView.text = ""
            btn.hidden = true
            return false;
        } else if text == "@" {
            // 是否为@
            textView.resignFirstResponder()
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
        if textView.text.characters.count == 0 {
            placeholder.hidden = false
        } else {
            placeholder.hidden = true
        }
    }
}
