//
//  ViewController.swift
//  YiNian
//
//  Created by 宏周 on 15/9/1.
//  Copyright (c) 2015年 Mars. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YNTextViewDelegate, ImagePickerDelegate {
    
    /// 列表试图
    @IBOutlet weak var tableView: UITableView!
    
    /// 输入试图
    @IBOutlet weak var textView: YNTextView!
    
    var shouldShow = !YNDBTool.hasTodayInsert()
    
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
        tableView.registerNib(UINib(nibName: "YNTimeCell", bundle: nil), forCellReuseIdentifier: "time")
        tableView.registerNib(UINib(nibName: "YNLeftCell", bundle: nil), forCellReuseIdentifier: "left")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        // 长按手势
        let long = UILongPressGestureRecognizer(target: self, action: Selector("long:"))
        long.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(long)
    }
    
    func setupTextView() {
        textView.delegate = self
        let swipe = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipe.delegate = self
        swipe.direction = .Up
        textView.addGestureRecognizer(swipe)
        textView.textView.panGestureRecognizer.requireGestureRecognizerToFail(swipe)
    }
    
    func swipe(swipe: UISwipeGestureRecognizer) {
        textView.endEditing(true)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.textView.transform = CGAffineTransformIdentity
        })
        self.isTextViewVisible = false
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
                YNDBTool.deleteTodayNian()
            }
        }
    }
    
    // MARK: - Table view delegate & data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("time", forIndexPath: indexPath) as! YNTimeCell
            cell.frame.size.width = UIScreen.mainScreen().bounds.width
            return cell
        } else if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! YNTableViewCell
            cell.nianF = datasource[indexPath.row - 1]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("left", forIndexPath: indexPath) as! YNLeftCell
            cell.nian = datasource[indexPath.row - 1].nian
            return cell
        }
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
        if gestureRecognizer.isKindOfClass(UISwipeGestureRecognizer.self) {
            let contentOffset = textView.textView.contentOffset
            let contentInset = textView.textView.contentInset
            let contentSize = textView.textView.contentSize
            let height = textView.textView.frame.height
            if contentSize.height < (height - contentInset.bottom) || contentOffset.y + (height - contentInset.bottom) == contentSize.height {
                return true
            }
            return false
        }
        return true
    }
    
    // MARK: - Text view delegate
    func textViewDidReturn(textView: UITextView, pic: UIImage?) {
        // 判断是否要过滤掉
        var flag = false
        for c in textView.text {
            if c != " " {
                flag = true
                break
            }
        }
        
        if !flag {
            if pic != nil {
                flag = true
            }
        }
        
        // 不过滤
        if flag {
            // 根据当前datasource计算index
            var index: Int
            if datasource.count > 0 {
                index = datasource[0].index + 1
            } else {
                index = 0
            }
            
            let nian = YNNian(date: NSDate(), text: textView.text, pic: nil)
            if let pic = pic {
                let data = UIImagePNGRepresentation(pic)
                let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String).stringByAppendingPathComponent(nian.strDate + ".png")
                data.writeToFile(path, atomically: true)
                nian.pic = path
            }
            YNDBTool.insertNian(nian)
            let nianF = YNNianFrame(nian: nian, index: index)
            self.datasource.insert(nianF, atIndex: 0)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 0)], withRowAnimation: .Fade)
        }
        
        // 隐藏textView
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.textView.transform = CGAffineTransformIdentity
        }) { (success) -> Void in
            if success {
                self.textView.placeholder.hidden = false
            }
        }
        
        self.isTextViewVisible = false
    }
    
    func textViewDidEnterPic() -> UIImage? {
        self.presentImagePickerSheet()
        return nil
    }
    
    // MARK: - Scroll view delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !shouldShow {
           return
        }
        let y = scrollView.contentOffset.y
        if isTextViewVisible { return }
        if y < 0 {
            textView.transform = CGAffineTransformMakeTranslation(0, -y);
        } else {
            textView.transform = CGAffineTransformIdentity
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !shouldShow {
            return
        }
        if textView.transform.ty > 100 {
            isTextViewVisible = true
            UIView.animateWithDuration(0.225, animations: { () -> Void in
                self.textView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.size.height)
            })
            textView.textView.becomeFirstResponder()
        }
    }
    
    // MARK: - Image Picker
    func presentImagePickerSheet() {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentImagePickerSheet()
                }
            }
            
            return
        }
        
        if authorization == .Authorized {
//            let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
//                let controller = UIImagePickerController()
//                controller.delegate = self
//                var sourceType = source
//                if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
//                    sourceType = .PhotoLibrary
//                    println("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
//                }
//                controller.sourceType = sourceType
//                
//                self.presentViewController(controller, animated: true, completion: nil)
//            }
            
            let controller = ImagePickerSheetController()
            controller.delegate = self
            
            
//            controller.addAction(ImageAction(title: NSLocalizedString("Take Photo Or Video", comment: "Action Title"), secondaryTitle: NSLocalizedString("Add comment", comment: "Action Title"), handler: { _ in
//                presentImagePickerController(.Camera)
//                }, secondaryHandler: { _, numberOfPhotos in
//                    println("Comment \(numberOfPhotos) photos")
//            }))
//            controller.addAction(ImageAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("ImagePickerSheet.button1.Send %lu Photo", comment: "Action Title"), $0) as String}, handler: { _ in
//                presentImagePickerController(.PhotoLibrary)
//                }, secondaryHandler: { _, numberOfPhotos in
//                    println("Send \(controller.selectedImageAssets)")
//            }))
//            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: { _ in
//                println("Cancelled")
//            }))
            
            presentViewController(controller, animated: true, completion: nil)
        }
        else {
            let alertView = UIAlertView(title: NSLocalizedString("An error occurred", comment: "An error occurred"), message: NSLocalizedString("ImagePickerSheet needs access to the camera roll", comment: "ImagePickerSheet needs access to the camera roll"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
            alertView.show()
        }
    }
    
    // MARK: - Image picker deleagte
    func imagePickerDidSelectImage(image: UIImage, frame: CGRect) {
        textView.selectImageView(image, frame: frame)
    }
    
    func imagePickerDidCancle() {
        textView.textView.becomeFirstResponder()
    }
}

