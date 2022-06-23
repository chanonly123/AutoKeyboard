//
//  ScrollViewController.swift
//  Auto Keyborad Demo
//
//  Created by Chandan Karmakar on 10/10/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import UIKit
import AutoKeyboard

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var tfAny: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAutoKeyboard { result in
            print("ScrollViewController: keyboard status \(result.status)")
            // to keep scroll position, also works with tableView
            // please restrict rotation, otherwise wont work correctly
            if result.status == .willChangeFrame && self.scrollView.reachedBottom {
                let delta = self.scrollView.contentOffset.y - (result.keyboardFrameEnd.origin.y - result.keyboardFrameBegin.origin.y)
                UIView.animate(withDuration: result.duration, delay: 0.0, options: [result.options], animations: { () -> Void in
                    self.scrollView.contentOffset = CGPoint(x: 0, y: delta)
                }, completion: nil)
            }
        }
    }
    
    @IBAction func bResingTap(_ sender: Any) {
        tfAny.resignFirstResponder()
    }
}

extension UIScrollView {
    
    var reachedBottom: Bool {
        get {
            return self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height)
        }
    }
    
}
