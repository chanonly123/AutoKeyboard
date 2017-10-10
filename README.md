# AutoKeyboard for iOS written in Swift

Automatic Keyboard handling with ease. It is fully automatic keyboard handling. Like in android no need to resize views when keyboard appears. It updates constraints which are bounded with `bottomLayoutGuide`. Feels like `bottomLayoutGuide` moves UP and DOWN with keyboard. Just need to `register` and `unResgister` thats it.

## []()
![alt tag](https://github.com/chanonly123/AutoKeyboard/blob/master/demo.gif)

## Features
- UITabBarController support added.
- UIViewController extension, no need to extend classes.
- Device rotation supported.
- Multiple UIViewController support.
- Extremely easy integration.
- Automatic bottom constraints changes with keyboard
- Resizing with animation.
- No need to write extra code.
- Just `registerAutoKeyboard ` and `unRegisterAutoKeyboard `.
- Callback support on keyboard willShow, didShow, willHide, didHide, willChangeFrame, didChangeFrame.
- Example for keeping scroll position of scrollView

## Runtime Requirements

- iOS8.0 or later
- Xcode 8.0 - Swift 3.0 or later

## Usage
### Basic Usage
![Alt text](https://github.com/chanonly123/AutoKeyboard/blob/master/help.png)<br />
- Add constrainsts to `bottomLayoutGuide` and they will update when keyboard appears.
- And Register your specific ViewController, you should also unregister.
```Swift
override func viewWillAppear(_ animated: Bool) {
registerAutoKeyboard()
}

override func viewWillDisappear(_ animated: Bool) {
unRegisterAutoKeyboard()
}
```
### Advanced Usage
```Swift
registerAutoKeyboard { (result) in
print("keyboard status \(result.status)")

switch result.status {
case .willShow:
// ...
case .didShow:
// ...
case .willHide:
// ...
case .didHide:
// ...
}
}
```
## Installing
### CocoaPods
To integrate AutoKeyboard into your Xcode project using CocoaPods, specify it in your `Podfile` and run `pod install`.
```bash
platform :ios, '8.0'
use_frameworks!
pod 'AutoKeyboard'                 // for swift 4
pod 'AutoKeyboard', '~> 1.0.3'     // for swift 3
```
And `import AutoKeyboard`
### Carthage
Coming soon

## Contributing

Contributions are always welcome!

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments
* Inspired by [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
* Motivated by [KeyboardObserver](https://github.com/morizotter/KeyboardObserver)
* Thanks to [Brian Mancini's iOSExamples-BottomScrollPosition](https://github.com/bmancini55/iOSExamples-BottomScrollPosition)

