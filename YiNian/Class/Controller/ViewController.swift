//
//  ViewController.swift
//  YiNian
//
//  Created by 宏周 on 15/9/1.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    // 输入文字视图
    lazy var editView: UIView = {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let frame = UIScreen.mainScreen().bounds
        let tableView = UITableView(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.yellowColor()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let sel = Selector("pan:")
        let pan = UIPanGestureRecognizer(target: self, action: sel)
        pan.delegate = self
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        tableView.addGestureRecognizer(pan)
        view.addSubview(tableView)
        view.addSubview(editView)
    }
    
    func pan(recognizer: UIPanGestureRecognizer) {
        if recognizer.translationInView(view).y > 0 {
            editView.frame.size.height = recognizer.translationInView(view).y
        }
        if recognizer.state == UIGestureRecognizerState.Ended {
            if editView.frame.height > 200 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    // 循环引用
                    self.editView.frame.size.height = self.view.frame.height
                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    // 循环引用
                    self.editView.frame.size.height = 0
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        println(touch.locationInView(view).y)
        return touch.locationInView(view).y < 150
    }
    
}

