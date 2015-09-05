//
//  ViewController.swift
//  YiNian
//
//  Created by 宏周 on 15/9/1.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YNTextViewDelegate {
    
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
        
        // 长按手势
        let long = UILongPressGestureRecognizer(target: self, action: Selector("long:"))
        long.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(long)
        
        // 拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        pan.delegate = self
        tableView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        tableView.addGestureRecognizer(pan)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        
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
    
    func long(lp: UILongPressGestureRecognizer) {
        if lp.state == UIGestureRecognizerState.Began {
            let point = lp.locationInView(tableView)
            if tableView.contentSize.height < point.y {
                return
            }
            let indexPath = tableView.indexPathForRowAtPoint(point)
            if indexPath?.row == 1 {
                datasource.removeAtIndex(0)
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
        }
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
    
    func presentImagePickerSheet(gestureRecognizer: UITapGestureRecognizer) {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentImagePickerSheet(gestureRecognizer)
                }
            }
            
            return
        }
        
        if authorization == .Authorized {
            let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
                let controller = UIImagePickerController()
                controller.delegate = self
                var sourceType = source
                if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                    sourceType = .PhotoLibrary
                    println("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
                }
                controller.sourceType = sourceType
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
            let controller = ImagePickerSheetController()
            controller.addAction(ImageAction(title: NSLocalizedString("Take Photo Or Video", comment: "Action Title"), secondaryTitle: NSLocalizedString("Add comment", comment: "Action Title"), handler: { _ in
                presentImagePickerController(.Camera)
                }, secondaryHandler: { _, numberOfPhotos in
                    println("Comment \(numberOfPhotos) photos")
            }))
            controller.addAction(ImageAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("ImagePickerSheet.button1.Send %lu Photo", comment: "Action Title"), $0) as String}, handler: { _ in
                presentImagePickerController(.PhotoLibrary)
                }, secondaryHandler: { _, numberOfPhotos in
                    println("Send \(controller.selectedImageAssets)")
            }))
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: { _ in
                println("Cancelled")
            }))
            
            presentViewController(controller, animated: true, completion: nil)
        }
        else {
            let alertView = UIAlertView(title: NSLocalizedString("An error occurred", comment: "An error occurred"), message: NSLocalizedString("ImagePickerSheet needs access to the camera roll", comment: "ImagePickerSheet needs access to the camera roll"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
            alertView.show()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

