
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

```
pod 'SwiftProgressView'
```

### Carthage

```
github "DerekCoder/SwiftProgressView"
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

- Drag UIView & Set Class
<img src="https://github.com/derekcoder/SwiftProgressView/blob/master/SwiftProgressViewDemo/setclass.png">

- Change Attributes
<img src="https://github.com/derekcoder/SwiftProgressView/blob/master/SwiftProgressViewDemo/attributes.png">

## Classes & Attributes & Methods

* `ProgressRingView` - The class for ring progress view
* `ProgressViewPieView` - The class for pie progress view
* `progress` - 0.0 ~ 1.0, readonly. Support IBInspectable
* `circleLineWidth` -  The width of outer circle. Support IBInspectable
* `circleColor` - The color of outer circle. Support IBInspectable
* `progressColor` - The color of inner circle. Support IBInspectable
* `animationDuration` - The duration of animation. Support IBInspectable
* `progressLineWidth` - The width of inner circle, only for ProgressRingView. Support IBInspectable
* `isShowPercentage` - Indicate whether percentage lable is displayed or not, only for ProgressRingView. Support IBInspectable
* `percentageFontSize` - The font size of percentage label, only for ProgressRingView. Support IBInspectable
* `percentageColor` - The color of percentage label, only for ProgressRingView. Support IBInspectable
* `spacing` - The spacing of outer and inner circle, only for ProgressPieView. Support IBInspectable
* `setProgress(_ progress: CGFloat, animated: Bool)` - The method to change progress with animation or not.

## Contact

- [Blog](http://blog.derekcoder.com)
- [Twitter](https://twitter.com/derekcoder_)
- [Weibo](https://weibo.com/u/6155322764)
- Email: derekcoder@gmail.com

## License

SwiftProgressView is released under the MIT license. [See LICENSE](https://github.com/derekcoder/SwiftProgressView/blob/master/LICENSE) for details.
