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
    
    @IBInspectable
    public var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var circleLineWidth: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var progressLineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var circleColor: UIColor = kDefaultBlueColor
    
    @IBInspectable
    public var progressColor: UIColor = kDefaultBlueColor
    
    @IBInspectable
    public var animationDuration: CGFloat = 0.7
    
    public func setProgress(_ progress: CGFloat, animated: Bool) {
		fatalError("Need be overrided by subclass")
    }
}

