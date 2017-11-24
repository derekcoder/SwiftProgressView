
# SwiftProgressView
[![Version](https://img.shields.io/cocoapods/v/SwiftProgressView.svg?style=flat)](http://cocoapods.org/pods/SwiftProgressView)
[![License](https://img.shields.io/cocoapods/l/SwiftProgressView.svg?style=flat)](http://cocoapods.org/pods/SwiftProgressView)
[![Platform](https://img.shields.io/cocoapods/p/SwiftProgressView.svg?style=flat)](http://cocoapods.org/pods/SwiftProgressView)

A set of progress views written in Swift.

<img src="https://github.com/derekcoder/SwiftProgressView/blob/master/SwiftProgressViewDemo/ring_demo.gif"> <img src="https://github.com/derekcoder/SwiftProgressView/blob/master/SwiftProgressViewDemo/pie_demo.gif">

## Requirements

- iOS 10.0+
- Swift 4

## Installation

### CocoaPods

```ruby
pod 'SwiftProgressView'
```

## Usage

### Programmatically

```swift
import SwiftProgressView

let frame = CGRect(x: 100, y: 100, width: 100, height: 100)
let progressView = ProgressPieView(frame: frame)
view.addSubview(progressView)
progressView.setProgress(1.0, animated: true)
```

### IB (storyboard)

- Set Class
<img src="https://github.com/derekcoder/SwiftProgressView/blob/master/SwiftProgressViewDemo/setclass.png">

- Change attributes
<img src="https://github.com/derekcoder/SwiftProgressView/blob/master/SwiftProgressViewDemo/attributes.png">


## Contact

- [Blog](http://blog.derekcoder.com)
- [Twitter](https://twitter.com/derekcoder_)
- [Weibo](https://weibo.com/u/6155322764)
- Email: derekcoder@gmail.com

## License

SwiftProgressView is released under the MIT license. [See LICENSE](https://github.com/derekcoder/SwiftProgressView/blob/master/LICENSE) for details.
