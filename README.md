# AutoKeyboard for iOS written in Swift 3.0

Automatic Keyboard handling with ease.

## Features
- UIViewController extension, no need to extend classes.
- Device rotation supported.
- Extremely easy integration.
- Automatic bottom constraints changes with keyboard
- Resizing with animation.
- No need to write extra code.
- Just `registerAutoKeyboard ` and `unRegisterAutoKeyboard `

## Runtime Requirements

- iOS8.0 or later
- Xcode 8.0 - Swift 3.0 or later

## Installing

### Manual

To install AutoKeyboard please add `AutoKeyboard.swift` to your Xcode Project.
And register your specific ViewController, you should also unregister.
```
    override func viewWillAppear(_ animated: Bool) {
        registerAutoKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unRegisterAutoKeyboard()
    }
```

### CocoaPods
To integrate AutoKeyboard into your Xcode project using CocoaPods, specify it in your `Podfile` and run `pod install`.
```bash
platform :ios, '8.0'
use_frameworks!
pod 'AutoKeyboard', :git => 'https://github.com/chanonly123/AutoKeyboard.git', :tag => '1.0.2'
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
