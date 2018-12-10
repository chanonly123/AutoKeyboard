//
//  ViewController.swift
//  Auto Keyborad Demo
//
//  Created by chanonly123 on 5/27/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import UIKit
import AutoKeyboard

class ViewController: UIViewController {
    
    @IBOutlet weak var tfAny: UITextField!
    @IBOutlet weak var lblBottom: NSLayoutConstraint!
    @IBOutlet weak var btnShowScrollBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerAutoKeyboard(enable: [lblBottom], disable: [btnShowScrollBottom]) { (result) in
            print("keyboard status \(result.status)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterAutoKeyboard()
    }
    
    @IBAction func bResingTap(_ sender: Any) {
        tfAny.resignFirstResponder()
    }
}



