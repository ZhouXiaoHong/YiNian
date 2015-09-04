//
//  ViewController.swift
//  YiNian
//
//  Created by 宏周 on 15/9/1.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, YNTextViewDelegate {
    
    /// 数据源数组
    var datasource = Array<YNNianFrame>()
    
    // 输入文字视图
    lazy var textView: YNTextView = {
        let frame = UIScreen.mainScreen().bounds
        let textView = NSBundle.mainBundle().loadNibNamed("YNTextView", owner: nil, options: nil)[0] as! YNTextView
        textView.delegate = self
//        textView.frame.size.height = 0
//        textView.transform = CGAffineTransformMakeScale(0, 0.001)
//        let x = textView.constraints()
        return textView
    }()
    
    /// tableview
    lazy var tableView: UITableView = {
        let frame = UIScreen.mainScreen().bounds
        let tableView = UITableView(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.yellowColor()
        tableView.registerClass(YNTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /// 手势依赖
        let sel = Selector("pan:")
        let pan = UIPanGestureRecognizer(target: self, action: sel)
        pan.delegate = self
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        tableView.addGestureRecognizer(pan)
        
        /// 添加子视图
        view.addSubview(tableView)
        view.addSubview(textView)
        
//        for i in 1...100 {
//            var text = ""
//            for j in 1...i {
//                let nianF = YNNianFrame(nian: YNNian(date: NSDate(timeIntervalSince1970: arc4random() % 100000000), text: "hahah", pic: "hah"), index: i)
//                datasource.append(nianF)
//            }
//        }
    }
    
    func pan(recognizer: UIPanGestureRecognizer) {
        if recognizer.translationInView(view).y > 0 {
            textView.frame.size.height = recognizer.translationInView(view).y
        }
        if recognizer.state == UIGestureRecognizerState.Ended {
            if textView.frame.height > 200 {
                UIView.animateWithDuration(10, animations: { () -> Void in
                    // 循环引用
                    self.textView.frame.size.height = self.view.frame.height
                    self.textView.transform = CGAffineTransformMakeScale(0, 2)
                })
            } else {
                UIView.animateWithDuration(10, animations: { () -> Void in
                    // 循环引用
                    self.textView.frame.size.height = 0
                })
            }
        }
    }
    
    // MARK: - Table view delegate & data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! YNTableViewCell
        if indexPath.row == 0 {
            let timeView = NSBundle.mainBundle().loadNibNamed("YNTimeView", owner: nil, options: nil)[0] as! YNTimeView
            timeView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44)
            cell.contentView.addSubview(timeView)
        } else {
            cell.nianF = datasource[indexPath.row - 1]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        } else {
            return 200
        }
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        cell.textView.text = datasource[indexPath.row]
//        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
//    }
    
    // MARK: - Gesture recognizer delegete
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.locationInView(view).y < 150
    }
    
    func textViewDidReturn() {
        let nian = YNNian(date: NSDate(), text: "hahahahah", pic: nil)
        let nianF = YNNianFrame(nian: nian, index: 1)
        self.datasource.insert(nianF, atIndex: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 0)], withRowAnimation: .Fade)
        
        let nian1 = YNNian(date: NSDate(), text: "hahah222ahah", pic: nil)
        let nianF1 = YNNianFrame(nian: nian1, index: 1)
        self.datasource.insert(nianF1, atIndex: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 0)], withRowAnimation: .Fade)
        
        textView.hidden = true
    }
}

