//
//  ProgressView.swift
//  Test
//
//  Created by Julie on 26/10/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

let kDefaultBlueColor = UIColor(red: 5/255.0, green: 117/255.0, blue: 255/255.0, alpha: 1.0)

@IBDesignable
public class ProgressView: UIView {
    
    @IBInspectable public internal(set) var progress: CGFloat = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable public var progressColor: UIColor = kDefaultBlueColor
    
    @IBInspectable public var animationDuration: CGFloat = 0.7
    
    public func setProgress(_ progress: CGFloat, animated: Bool) {
        fatalError("Need be overrided by subclass")
    }
    
    // MARK: - Background Layer
    
    var backgroundLayer: CAShapeLayer!
    
    @IBInspectable public var circleLineWidth: CGFloat = 1 {
        didSet {
            backgroundLayer.lineWidth = circleLineWidth
            setNeedsDisplay()
        }
    }
    @IBInspectable public var circleColor: UIColor = kDefaultBlueColor {
        didSet {
            backgroundLayer.strokeColor = circleColor.cgColor
            setNeedsDisplay()
        }
    }
    
    // MARK: - Drawing
    var centerPoint: CGPoint {
        var center: CGPoint = .zero
        center.x = (bounds.size.width - bounds.origin.x) / 2
        center.y = (bounds.size.height - bounds.origin.y) / 2
        return center
    }

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
}

