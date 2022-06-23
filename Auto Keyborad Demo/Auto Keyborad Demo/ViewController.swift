//
//  ViewController.swift
//  Auto Keyborad Demo
//
//  Created by chanonly123 on 5/27/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import AutoKeyboard
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tfAny: UITextField!
    @IBOutlet weak var lblBottom: NSLayoutConstraint!
    @IBOutlet weak var btnShowScrollBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAutoKeyboard(enable: [lblBottom], disable: [btnShowScrollBottom]) { result in
            print("keyboard status \(result.status)")
        }
    }
    
    @IBAction func bResingTap(_ sender: Any) {
        tfAny.resignFirstResponder()
    }
}

extension ViewController: AutoKeyboardOptions {
    var customTabbarExtraHeight: CGFloat { 0 }
}
