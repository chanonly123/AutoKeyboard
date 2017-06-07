# AutoKeyboard for iOS written in Swift 3.0

__Full Automatic__ Keyboard handling with __Zero__ line of Code. Like in android no need to resize views when keyboard appears. It updates constraints which are bounded with `bottomLayoutGuide`. It Feels like `bottomLayoutGuide` moving UP and DOWN with keyboard. Thats it.

## []()
![alt tag](https://github.com/chanonly123/AutoKeyboard/blob/master/demo.gif)

## Features
- Zero line of code.
- Device rotation supported.
- Extremely easy integration.
- Automatic bottom constraints changes with keyboard.
- Resizing with animation.

## Runtime Requirements
- iOS8.0 or later
- Xcode 8.0 - Swift 3.0 or later

## Usage
![Alt text](https://github.com/chanonly123/AutoKeyboard/blob/master/help.png)<br />
- Install __AutoKeyboard__.
- Add constrainsts to `bottomLayoutGuide` and they will change when keyboard appears.
- Enjoy.

#### Important Note
- This library uses methods `viewWillAppear` and `viewWillDisappear` by __swizzling__ to __register__ and __unRegister__ keyboard notification.
- If you are overriding `viewWillAppear` then make sure to call `super.viewWillAppear(animated)`.
- If you are overriding `viewWillDisappear` then make sure to call `super.viewWillDisappear(animated)`.

## Installing
### CocoaPods
To integrate __AutoKeyboard__ into your Xcode project using CocoaPods, specify it in your `Podfile` and run `pod install`.
```bash
platform :ios, '8.0'
use_frameworks!
pod 'AutoKeyboard'
```
And `import AutoKeyboard`
### Carthage
Coming soon

## Contributing

Contributions are always welcome!
Contact `chan.only.123@gmail.com`

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Inspired by [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
* Motivated by [KeyboardObserver](https://github.com/morizotter/KeyboardObserver)
