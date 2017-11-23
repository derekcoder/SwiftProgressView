//
//  ProgressRingView.swift
//  Test
//
//  Created by Julie on 31/10/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

public class ProgressRingView: ProgressView {
	
    private var displayLink: CADisplayLink?
    private var animationFromValue: CGFloat = 0
    private var animationToValue: CGFloat = 0
    private var animationStartTime: CFTimeInterval = 0
    
    private var progressLayer: CAShapeLayer!
    private var backgroundLayer: CAShapeLayer!
    
    override public var progressColor: UIColor {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
            setNeedsDisplay()
        }
    }
    
    override public var circleColor: UIColor {
        didSet {
            backgroundLayer.strokeColor = circleColor.cgColor
            setNeedsDisplay()
        }
    }
    
    public override var progressLineWidth: CGFloat {
        didSet {
            progressLayer.lineWidth = progressLineWidth
            setNeedsDisplay()
        }
    }
    
    public override var circleLineWidth: CGFloat {
        didSet {
            backgroundLayer.lineWidth = circleLineWidth
            setNeedsDisplay()
        }
    }
    
    public var progressLineCapStyle: CGLineCap = .butt {
        didSet {
            backgroundLayer.lineCap = self.lineCap(from: progressLineCapStyle)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var isShowText: Bool = true { didSet { setNeedsDisplay() } }
    @IBInspectable public var textFontSize: CGFloat = 15 { didSet { setNeedsDisplay() } }
    @IBInspectable public var textFontColor: UIColor = kDefaultBlueColor { didSet { setNeedsDisplay() } }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        
        backgroundLayer = CAShapeLayer()
        backgroundLayer.strokeColor = circleColor.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.lineWidth = circleLineWidth
        layer.addSublayer(backgroundLayer)
        
        progressLayer = CAShapeLayer()
        progressLayer.fillColor = nil
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.lineCap = self.lineCap(from: progressLineCapStyle)
        progressLayer.lineWidth = progressLineWidth
        layer.addSublayer(progressLayer)
    }
    
    private func lineCap(from capStyle: CGLineCap) -> String {
        switch capStyle {
        case .butt: return kCALineCapButt
        case .round: return kCALineCapRound
        case .square: return kCALineCapSquare
        }
    }
    
    // MARK: - Public
    public override func setProgress(_ progress: CGFloat, animated: Bool) {
        if self.progress == progress { return }
        
        if !animated {
            if displayLink != nil {
                displayLink!.invalidate()
                displayLink = nil
            }
            self.progress = progress
            setNeedsDisplay()
        } else {
            animationStartTime = CACurrentMediaTime()
            animationFromValue = self.progress
            animationToValue = progress
            if displayLink == nil {
                displayLink = CADisplayLink(target: self, selector: #selector(self.animationProgress(_:)))
                displayLink!.add(to: RunLoop.main, forMode: .commonModes)
            }
        }
    }
    
    @objc private func animationProgress(_ sender: CADisplayLink) {
        DispatchQueue.main.async {
            let dt = CGFloat(self.displayLink!.timestamp - self.animationStartTime) / self.animationDuration
            if dt >= 1.0 {
                self.displayLink!.invalidate()
                self.displayLink = nil
                self.progress = self.animationToValue
                self.setNeedsDisplay()
            } else {
                self.progress = self.animationFromValue + dt * (self.animationToValue - self.animationFromValue)
                self.setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Drawing
    private var centerPoint: CGPoint {
        var center: CGPoint = .zero
        center.x = (bounds.size.width - bounds.origin.x) / 2
        center.y = (bounds.size.height - bounds.origin.y) / 2
        return center
    }
    
    override public func draw(_ rect: CGRect) {
        drawBackground()
        drawProgress()
        drawText()
    }
    
    private func drawBackground() {
        let start = -CGFloat.pi / 2.0
        let end = start + (2.0 * CGFloat.pi)
        let radius = (bounds.size.width - circleLineWidth) / 2
        
        let path = UIBezierPath()
        path.lineWidth = circleLineWidth
        path.lineCapStyle = .round
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        backgroundLayer.path = path.cgPath
    }
    
    private func drawProgress() {
        let start = -CGFloat.pi / 2.0
        let end = start + (2.0 * CGFloat.pi * progress)
        let radius = (bounds.size.width / 2.0) - circleLineWidth - (progressLineWidth / 2.0)
        
        let path = UIBezierPath()
        path.lineCapStyle = progressLineCapStyle
        path.lineWidth = progressLineWidth
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        progressLayer.path = path.cgPath
    }
    
    private var percentageSymbolAttributes: [NSAttributedStringKey : Any] {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .left
        let font = UIFont.systemFont(ofSize: textFontSize)
        let attributes: [NSAttributedStringKey : Any] = [.font: font, .foregroundColor: textFontColor, .paragraphStyle: paragraphStyle]
        return attributes
    }
    
    private var percentageTextAttributes: [NSAttributedStringKey : Any] {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .right
        let font = UIFont.systemFont(ofSize: textFontSize)
        let attributes: [NSAttributedStringKey : Any] = [.font: font, .foregroundColor: textFontColor, .paragraphStyle: paragraphStyle]
        return attributes
    }
    
    private func drawText() {
        let text = "\(Int(round(Double(progress * 100))))"
        let textAttributes = self.percentageTextAttributes
        let maxRect = CGRect(x: 0, y: 0, width: bounds.size.width/2.0, height: bounds.size.height)
        let textRect = text.boundingRect(with: maxRect.size, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        let textDrawRect = CGRect(x: maxRect.minX,
                            	  y: maxRect.minY + (maxRect.height - textRect.height) * 0.5,
                            	width: maxRect.width,
                             	 height: textRect.height)
        text.draw(in: textDrawRect, withAttributes: textAttributes)
        
        let symbol = "%" as NSString
        let symbolAttributes = self.percentageSymbolAttributes
        let symbolRect = symbol.boundingRect(with: maxRect.size, options: .usesLineFragmentOrigin, attributes: symbolAttributes, context: nil)
        let symbolDrawRect = CGRect(x: maxRect.minX + maxRect.width,
                                  	y: maxRect.minY + (maxRect.height - symbolRect.height) * 0.5,
                                 	 width: maxRect.width,
                                 	 height: symbolRect.height)
        symbol.draw(in: symbolDrawRect, withAttributes: symbolAttributes)
    }
}
