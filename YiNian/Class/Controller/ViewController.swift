//
//  ViewController.swift
//  YiNian
//
//  Created by 宏周 on 15/9/1.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    /// 数据源数组
    var datasource = Array<String>()
    
    // 输入文字视图
    lazy var textView: YNTextView = {
        let frame = UIScreen.mainScreen().bounds
//        let textView = YNTextView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
        let textView = NSBundle.mainBundle().loadNibNamed("YNTextView", owner: nil, options: nil)[0] as! YNTextView
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
        
        for i in 1...100 {
            var text = ""
            for j in 1...i {
                text += "Auto Layout"
            }
            datasource.append(text)
        }
    }
    
    func pan(recognizer: UIPanGestureRecognizer) {
        if recognizer.translationInView(view).y > 0 {
            textView.frame.size.height = recognizer.translationInView(view).y
        }
        if recognizer.state == UIGestureRecognizerState.Ended {
            if textView.frame.height > 200 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    // 循环引用
                    self.textView.frame.size.height = self.view.frame.height
                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    // 循环引用
                    self.textView.frame.size.height = 0
                })
            }
        }
    }
    
    // MARK: - Table view delegate & data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! YNTableViewCell
        let text = datasource[indexPath.row]
        
        cell.nianF = YNNianFrame(nian: YNNian(date: NSDate(), text: datasource[indexPath.row], pic: "hah"), index: indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        cell.textView.text = datasource[indexPath.row]
//        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
//    }
    
    // MARK: - Gesture recognizer delegete
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.locationInView(view).y < 150
    }
}

