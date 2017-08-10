//
//  Extenstions.swift
//  AutoKeyboard
//
//  Created by chanonly123 on 5/27/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import UIKit

fileprivate var savedConstant:[UIViewController:[NSLayoutConstraint:CGFloat]] = [:]

extension UIViewController {
    
    public func registerAutoKeyboard() {
        print("Adding observers")
        
        var consts:[NSLayoutConstraint:CGFloat] = [:]
        for each in getBottomConstrainsts() {
            consts[each] = each.constant
        }
        savedConstant[self] = consts
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    public func unRegisterAutoKeyboard() {
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        savedConstant.removeValue(forKey: self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if let saved = savedConstant[self] {
            let const = getBottomConstrainsts()
            for each in const {
                if let savedValue = saved[each] {
                    let tabBarHeight : CGFloat = (tabBarController?.tabBar.isHidden ?? true) ? 0 : tabBarController?.tabBar.bounds.height ?? 0
                    each.constant = savedValue + keyboardFrameEnd.height - tabBarHeight
                }
            }
            animateWithKeyboardEventNotified(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let saved = savedConstant[self] {
            let const = getBottomConstrainsts()
            for each in const {
                if let savedValue = saved[each] {
                    each.constant = savedValue
                }
            }
            animateWithKeyboardEventNotified(notification: notification)
        }
    }
    
    func getBottomConstrainsts() -> [NSLayoutConstraint] {
        var consts:[NSLayoutConstraint] = []
        for each in self.view.constraints {
            if (each.firstItem === self.bottomLayoutGuide && each.firstAttribute == .top && each.secondAttribute == .bottom) || (each.secondItem === self.bottomLayoutGuide && each.secondAttribute == .top && each.firstAttribute == .bottom) {
                consts.append(each)
            }
        }
        return consts
    }
    
    private func animateWithKeyboardEventNotified(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let options = UIViewAnimationOptions(rawValue: UInt(curve.rawValue << 16))
        let duration = TimeInterval(userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber)
        UIView.animate(withDuration: duration, delay: 0.0, options: [options], animations:
            { [weak self] () -> Void in
                self!.view.layoutIfNeeded()
            } , completion: nil)
    }
    
}

