//
//  Extenstions.swift
//  AutoKeyboard
//
//  Created by chanonly123 on 5/27/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import UIKit

class GroupItem {
    var handler: ((_ show: KeyboardResult) -> Void)?
    var constraints = [NSLayoutConstraint: CGFloat]()
    var willShowCalled = false
}

private var savedObservers = NSMapTable<UIViewController, GroupItem>(keyOptions: .weakMemory, valueOptions: .strongMemory)

public class KeyboardResult {
    public let notification: NSNotification
    public let userInfo: [AnyHashable: Any]
    public let status: KeyboardStatus
    public let curve: UIView.AnimationCurve
    public let options: UIView.AnimationOptions
    public let duration: TimeInterval
    public let keyboardFrameBegin: CGRect
    public let keyboardFrameEnd: CGRect
    
    init(notification: NSNotification,
         userInfo: [AnyHashable: Any],
         status: KeyboardStatus,
         curve: UIView.AnimationCurve,
         options: UIView.AnimationOptions,
         duration: TimeInterval,
         keyboardFrameBegin: CGRect,
         keyboardFrameEnd: CGRect)
    {
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

public protocol AutoKeyboardOptions {
    var customTabbarExtraHeight: CGFloat { get }
}

extension UIViewController {
    /**
     Registers keyboard observers with constraints linked to SafeArea.Bottom or LayoutGuide.Bottom.
     - Parameter enable: to register constraints other than defaults
     - Parameter disable: to disable constraints
     */
    public func registerAutoKeyboard(enable: [NSLayoutConstraint] = [], disable: [NSLayoutConstraint] = [], observer: ((_ show: KeyboardResult) -> Void)? = nil) {
        print("Registering AutoKeyboard to: \(NSStringFromClass(type(of: self)))")
        
        var consts: [NSLayoutConstraint: CGFloat] = [:]
        for each in getBottomConstrainsts() {
            consts[each] = each.constant
        }
        for each in enable {
            consts[each] = each.constant
        }
        
        for each in disable {
            consts[each] = nil
        }
        
        let group = GroupItem()
        group.handler = observer
        group.constraints = consts
        
        savedObservers.setObject(group, forKey: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionKeyboardDidChangeFrame(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    /**
     Unregisters keyboard observers. Can be called from deinit (optional).
     */
    public func unRegisterAutoKeyboard() {
        print("Unregistering AutoKeyboard from: \(NSStringFromClass(type(of: self)))")
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        savedObservers.removeObject(forKey: self)
    }
    
    func getTopController() -> UIViewController? {
        if var topController = UIApplication.shared.windows.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    @objc func actionKeyboardWillShow(notification: NSNotification) {
        if view.firstResponder == nil { return }
        if let result = decodeNotification(notification: notification, status: .willShow) {
            if let group = savedObservers.object(forKey: self) {
                group.willShowCalled = true
                keyboardShow(result: result)
            }
        }
    }
    
    @objc func actionKeyboardDidShow(notification: NSNotification) {
        var groupItem: GroupItem?
        defer {
            groupItem?.willShowCalled = false
        }
        if view.firstResponder == nil { return }
        if let result = decodeNotification(notification: notification, status: .didShow) {
            if let group = savedObservers.object(forKey: self) {
                groupItem = group
                if !group.willShowCalled {
                    keyboardShow(result: result)
                    return
                }
            }
            savedObservers.object(forKey: self)?.handler?(result)
        }
    }
    
    @objc func actionKeyboardWillHide(notification: NSNotification) {
        if view.firstResponder == nil { return }
        if let result = decodeNotification(notification: notification, status: .willHide) {
            keyboardHide(result: result)
        }
    }
    
    @objc func actionKeyboardDidHide(notification: NSNotification) {
        if view.firstResponder == nil { return }
        if let result = decodeNotification(notification: notification, status: .didHide) {
            savedObservers.object(forKey: self)?.handler?(result)
        }
    }
    
    @objc func actionKeyboardWillChangeFrame(notification: NSNotification) {
        if view.firstResponder == nil { return }
        if let result = decodeNotification(notification: notification, status: .willChangeFrame) {
            savedObservers.object(forKey: self)?.handler?(result)
        }
    }
    
    @objc func actionKeyboardDidChangeFrame(notification: NSNotification) {
        if view.firstResponder == nil { return }
        if let result = decodeNotification(notification: notification, status: .didChangeFrame) {
            savedObservers.object(forKey: self)?.handler?(result)
        }
    }
    
    private func keyboardShow(result: KeyboardResult) {
        if let group = savedObservers.object(forKey: self) {
            let saved = group.constraints
            for each in saved {
                let tabBarHeight: CGFloat = (tabBarController?.tabBar.isHidden ?? true) ? 0 : tabBarController?.tabBar.bounds.height ?? 0
                let customHeight = (self as? AutoKeyboardOptions)?.customTabbarExtraHeight ?? 0
                var iPhoneXExtra: CGFloat = 0
                if #available(iOS 11.0, *) {
                    if view.safeAreaInsets.bottom > 0 {
                        iPhoneXExtra = view.safeAreaInsets.bottom
                    }
                }
                each.key.constant = each.value + result.keyboardFrameEnd.height - tabBarHeight - iPhoneXExtra - customHeight
            }
            animateWithKeyboardEventNotified(result: result)
            group.handler?(result)
        }
    }
    
    private func keyboardHide(result: KeyboardResult) {
        if let group = savedObservers.object(forKey: self) {
            let saved = group.constraints
            for each in saved {
                each.key.constant = each.value
            }
            animateWithKeyboardEventNotified(result: result)
            group.handler?(result)
        }
    }
    
    private func getBottomConstrainsts() -> [NSLayoutConstraint] {
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
                        each.firstAttribute == .bottom)
                {
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
                        each.firstAttribute == .bottom)
                {
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
                        each.firstAttribute == .bottom)
                {
                    consts.append(each)
                }
            }
        }
        return consts
    }
    
    private func decodeNotification(notification: NSNotification, status: KeyboardStatus) -> KeyboardResult? {
        guard let userInfo = notification.userInfo else { return nil }
        let keyboardFrameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrameBegin = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let curve = UIView.AnimationCurve(rawValue: (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let options = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let result = KeyboardResult(notification: notification, userInfo: userInfo, status: status, curve: curve, options: options, duration: duration, keyboardFrameBegin: keyboardFrameBegin, keyboardFrameEnd: keyboardFrameEnd)
        
        return result
    }
    
    private func animateWithKeyboardEventNotified(result: KeyboardResult) {
        UIView.animate(withDuration: result.duration, delay: 0.0, options: [result.options], animations: { [weak self] () -> Void in
            self!.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}

