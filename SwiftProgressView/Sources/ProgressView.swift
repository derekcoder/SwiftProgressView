//
//  ProgressView.swift
//  Test
//
//  Created by Derek on 26/10/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

struct Constants {
    struct Color {
        static let blue = UIColor(red: 5/255.0, green: 117/255.0, blue: 255/255.0, alpha: 1.0)
        static let green = UIColor(red: 96/255.0, green: 186/255.0, blue: 125/255.0, alpha: 1.0)
        static let red = UIColor.red
    }
}

@IBDesignable
public class ProgressView: UIView {
    var displayLink: CADisplayLink?
    var animationFromValue: CGFloat = 0
    var animationToValue: CGFloat = 0
    var animationStartTime: CFTimeInterval = 0

    @IBInspectable public internal(set) var progress: CGFloat = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable public var progressColor: UIColor = Constants.Color.blue
    @IBInspectable public var animationDuration: CGFloat = 0.7
    public var observedProgress: Progress? {
        didSet {
            oldValue?.removeObserver(self, forKeyPath: keyPathToObservedProgress)
            observedProgress?.addObserver(self, forKeyPath: keyPathToObservedProgress, options: [.new], context: nil)
        }
    }
    
    public func setProgress(_ progress: CGFloat, animated: Bool) {
        fatalError("Need be overrided by subclass")
    }
    
    public var isOver: Bool = false {
        didSet {
            observedProgress?.removeObserver(self, forKeyPath: keyPathToObservedProgress)
            observedProgress = nil
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var indicatorFontSize: CGFloat = 15 { didSet { setNeedsDisplay() } }
    @IBInspectable public var successIndicatorColor: UIColor = Constants.Color.green { didSet { setNeedsDisplay() } }
    @IBInspectable public var failureIndicatorColor: UIColor = Constants.Color.red { didSet { setNeedsDisplay() } }
    public var isCompleted: Bool { return progress == 1.0 }
    public var indicator: String { return isCompleted ? "✓" : "✕" }
    
    // MARK: - Observer
    
    private let keyPathToObservedProgress = "fractionCompleted"
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == keyPathToObservedProgress else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        guard let value = change?[.newKey] as? Double else { return }
        var progress = CGFloat(value)
        if progress < 0 { progress = 0 }
        if progress > 1 { progress = 1 }
        self.setProgress(progress, animated: true)
    }
    
    // MARK: - Background Layer
    
    var backgroundLayer: CAShapeLayer!
    
    @IBInspectable public var circleLineWidth: CGFloat = 1 {
        didSet {
            backgroundLayer.lineWidth = circleLineWidth
            setNeedsDisplay()
        }
    }
    @IBInspectable public var circleColor: UIColor = Constants.Color.blue {
        didSet {
            backgroundLayer.strokeColor = circleColor.cgColor
            setNeedsDisplay()
        }
    }
    
    // MARK: - Drawing
    
    func drawBackground() {
        let start = -CGFloat.pi / 2.0
        let end = start + (2.0 * CGFloat.pi)
        let radius = (bounds.size.width - circleLineWidth) / 2
        
        let path = UIBezierPath()
        path.lineWidth = circleLineWidth
        path.lineCapStyle = .round
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        backgroundLayer.path = path.cgPath
    }
    
    func drawIndicator() {
        let font = UIFont.systemFont(ofSize: indicatorFontSize)
        let textAttributes = self.textAttributes(withFont: font, alignment: .center, foregroundColor: isCompleted ? successIndicatorColor : failureIndicatorColor)
        let maxTextRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        let textRect = indicator.boundingRect(with: maxTextRect.size, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        let textDrawRect = CGRect(x: maxTextRect.minX,
                                  y: maxTextRect.minY + (maxTextRect.height - textRect.height) * 0.5,
                                  width: maxTextRect.width,
                                  height: textRect.height)
        indicator.draw(in: textDrawRect, withAttributes: textAttributes)
    }
    
    var centerPoint: CGPoint {
        var center: CGPoint = .zero
        center.x = (bounds.size.width - bounds.origin.x) / 2
        center.y = (bounds.size.height - bounds.origin.y) / 2
        return center
    }
    
    func textAttributes(withFont font: UIFont, alignment: NSTextAlignment, foregroundColor: UIColor) -> [NSAttributedStringKey: Any] {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = alignment
        let attributes: [NSAttributedStringKey : Any] = [.font: font, .foregroundColor: foregroundColor, .paragraphStyle: paragraphStyle]
        return attributes
    }
}

