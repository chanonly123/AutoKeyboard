//
//  Extenstions.swift
//  AutoKeyboard
//
//  Created by chanonly123 on 5/27/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import UIKit

fileprivate var savedFrame : CGRect!

fileprivate let autoKeyboardNotifications = [
	NSNotification.Name.UIKeyboardWillShow,
	NSNotification.Name.UIKeyboardWillHide,
	NSNotification.Name.UIKeyboardWillChangeFrame
]

extension UIViewController {
	
	public func registerAutoKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
	}
	
	public func unRegisterAutoKeyboard() {
		self.view.endEditing(true)
		autoKeyboardNotifications.forEach {
			NotificationCenter.default.removeObserver(self, name: $0, object: nil)
		}
	}
	
	func keyboardWillShow(notification: NSNotification) {
		//print("keyboardWillShow")
		guard let userInfo = notification.userInfo else { return }
		let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		self.view.frame = CGRect(x: 0, y: 0, width: savedFrame!.width, height: savedFrame!.height - keyboardFrameEnd.height)
		animateWithKeyboardEventNotified(notification: notification)
	}
	
	func keyboardWillHide(notification: NSNotification) {
		//print("keyboardWillHide")
		//guard let userInfo = notification.userInfo else { return }
		//let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		self.view.frame = savedFrame!
		animateWithKeyboardEventNotified(notification: notification)
	}
	
	func keyboardWillChangeFrame(notification: NSNotification) {
		savedFrame = CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
		//print("keyboardWillChangeFrame \(savedFrame)")
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

