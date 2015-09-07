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
    
    /// 列表试图
    @IBOutlet weak var tableView: UITableView!
    
    /// 输入试图
    @IBOutlet weak var textView: YNTextView!
    
    /// 数据源数组
    var datasource: Array<YNNianFrame> = {
        var datasource = Array<YNNianFrame>()
        let ary = YNDBTool.queryAllNian()
        for i in 0..<ary.count {
            datasource.append(YNNianFrame(nian: ary[i], index: i))
        }
        return datasource
    }()
    
    /// 输入试图是否应该显示
    var isTextViewVisible = false

    @IBOutlet weak var textViewY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.   
        
        
        self.setupTableView()
        self.setupTextView()
    }
    
    func setupTableView() {
        tableView.registerClass(YNTableViewCell.self, forCellReuseIdentifier: "cell")

        // 长按手势
        let long = UILongPressGestureRecognizer(target: self, action: Selector("long:"))
        long.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(long)
    }
    
    func setupTextView() {
        textView.delegate = self
    }
    
    // MARK: - Gesture func
    /**
    长按手势
    
    :param: lp lp
    */
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
    
    // MARK: - Gesture recognizer delegete
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.locationInView(view).y < 150
    }
    
    
    
    // MARK: - Text view delegate
    func textViewDidReturn(textView: UITextView, pic: String?) {
        var index: Int
        if datasource.count > 0 {
            index = datasource[0].index + 1
        } else {
            index = 0
        }
        
        let nian = YNNian(date: NSDate(), text: textView.text, pic: nil)
        let nianF = YNNianFrame(nian: nian, index: index)
        self.datasource.insert(nianF, atIndex: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 0)], withRowAnimation: .Fade)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.textView.transform = CGAffineTransformIdentity
        })
        self.isTextViewVisible = false
    }
    
    // MARK: - Scroll view delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if isTextViewVisible { return }
        if y < 0 {
            textView.transform = CGAffineTransformMakeTranslation(0, -y);
        } else {
            textView.transform = CGAffineTransformIdentity
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if textView.transform.ty > 100 {
            isTextViewVisible = true
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.textView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.size.height)
            })
            textView.textView.becomeFirstResponder()
        }
    }
    
    // MARK: - Image Picker
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
    
    /// tableview
    //    lazy var tableView: UITableView = {

    //        
    //        return tableView
    //    }()
}

