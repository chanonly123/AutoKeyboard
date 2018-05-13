//
//  Extenstions.swift
//  AutoKeyboard
//
//  Created by chanonly123 on 5/27/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import UIKit

fileprivate var savedConstant: [UIViewController: [NSLayoutConstraint: CGFloat]] = [:]
fileprivate var savedObservers: [UIViewController: ((_ show: KeyboardResult) -> Void)] = [:]

public class KeyboardResult {
    public let notification: NSNotification
    public let userInfo: [AnyHashable: Any]
    public let status: KeyboardStatus
    public let curve: UIViewAnimationCurve
    public let options: UIViewAnimationOptions
    public let duration: TimeInterval
    public let keyboardFrameBegin: CGRect
    public let keyboardFrameEnd: CGRect
    
    init(notification: NSNotification,
         userInfo: [AnyHashable: Any],
         status: KeyboardStatus,
         curve: UIViewAnimationCurve,
         options: UIViewAnimationOptions,
         duration: TimeInterval,
         keyboardFrameBegin: CGRect,
         keyboardFrameEnd: CGRect) {
        self.notification = notification
        self.userInfo = userInfo
        self.status = status
        self.curve = curve
        self.options = options
        self.duration = duration
        self.keyboardFrameBegin = keyboardFrameBegin
        self.keyboardFrameEnd = keyboardFrameEnd
    }
}

public enum KeyboardStatus: String {
    case willShow, willHide, didShow, didHide, willChangeFrame, didChangeFrame
}

extension UIViewController {
    public func registerAutoKeyboard(observer: ((_ show: KeyboardResult) -> Void)? = nil) {
        print("Adding observers")
        
        var consts: [NSLayoutConstraint: CGFloat] = [:]
        for each in getBottomConstrainsts() {
            consts[each] = each.constant
        }
        savedConstant[self] = consts
        
        if observer != nil {
            savedObservers[self] = observer
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    public func unRegisterAutoKeyboard() {
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        savedConstant.removeValue(forKey: self)
        savedObservers.removeValue(forKey: self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let result = decodeNotification(notification: notification, status: .willShow) {
            if let saved = savedConstant[self] {
                let const = getBottomConstrainsts()
                for each in const {
                    if let savedValue = saved[each] {
                        let tabBarHeight: CGFloat = (tabBarController?.tabBar.isHidden ?? true) ? 0 : tabBarController?.tabBar.bounds.height ?? 0
                        each.constant = savedValue + result.keyboardFrameEnd.height - tabBarHeight
                    }
                }
                animateWithKeyboardEventNotified(result: result)
            }
            
            if let observer = savedObservers[self] {
                observer(result)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let result = decodeNotification(notification: notification, status: .willHide) {
            if let saved = savedConstant[self] {
                let const = getBottomConstrainsts()
                for each in const {
                    if let savedValue = saved[each] {
                        each.constant = savedValue
                    }
                }
                animateWithKeyboardEventNotified(result: result)
            }
            
            if let observer = savedObservers[self] {
                observer(result)
            }
        }
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let result = decodeNotification(notification: notification, status: .didShow) {
            if let observer = savedObservers[self] {
                observer(result)
            }
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        if let result = decodeNotification(notification: notification, status: .didHide) {
            if let observer = savedObservers[self] {
                observer(result)
            }
        }
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let result = decodeNotification(notification: notification, status: .willChangeFrame) {
            if let observer = savedObservers[self] {
                observer(result)
            }
        }
    }
    
    @objc func keyboardDidChangeFrame(notification: NSNotification) {
        if let result = decodeNotification(notification: notification, status: .didChangeFrame) {
            if let observer = savedObservers[self] {
                observer(result)
            }
        }
    }
    
    func getBottomConstrainsts() -> [NSLayoutConstraint] {
        var consts: [NSLayoutConstraint] = []
        if #available(iOS 11.0, *) {
            let safeArea = self.view.safeAreaLayoutGuide
            for each in self.view.constraints {
                if (each.firstItem === safeArea &&
                    each.firstAttribute == .bottom &&
                    each.secondItem !== self.view &&
                    each.secondAttribute == .bottom) ||
                    (each.secondItem === safeArea &&
                        each.secondAttribute == .bottom &&
                        each.firstItem !== self.view &&
                        each.firstAttribute == .bottom) {
                    consts.append(each)
                }
            }
            let guide = self.bottomLayoutGuide
            for each in self.view.constraints {
                if (each.firstItem === guide &&
                    each.firstAttribute == .top &&
                    each.secondItem !== self.view &&
                    each.secondAttribute == .bottom) ||
                    (each.secondItem === guide &&
                        each.secondAttribute == .top &&
                        each.firstItem !== self.view &&
                        each.firstAttribute == .bottom) {
                    consts.append(each)
                }
            }
        } else {
            let guide = bottomLayoutGuide
            for each in view.constraints {
                if (each.firstItem === guide &&
                    each.firstAttribute == .top &&
                    each.secondItem !== view &&
                    each.secondAttribute == .bottom) ||
                    (each.secondItem === guide &&
                        each.secondAttribute == .top &&
                        each.firstItem !== view &&
                        each.firstAttribute == .bottom) {
                    consts.append(each)
                }
            }
        }
        return consts
    }
    
    private func decodeNotification(notification: NSNotification, status: KeyboardStatus) -> KeyboardResult? {
        guard let userInfo = notification.userInfo else { return nil }
        let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let options = UIViewAnimationOptions(rawValue: UInt(curve.rawValue << 16))
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let result = KeyboardResult(notification: notification, userInfo: userInfo, status: status, curve: curve, options: options, duration: duration, keyboardFrameBegin: keyboardFrameBegin, keyboardFrameEnd: keyboardFrameEnd)
        
        return result
    }
    
    private func animateWithKeyboardEventNotified(result: KeyboardResult) {
        UIView.animate(withDuration: result.duration, delay: 0.0, options: [result.options], animations: { [weak self] () -> Void in
            self!.view.layoutIfNeeded()
        }, completion: nil)
    }
}
