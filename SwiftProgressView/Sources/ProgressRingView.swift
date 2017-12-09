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
    
    override public var progressColor: UIColor {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
            setNeedsDisplay()
        }
    }
    
    public var progressLineCapStyle: CGLineCap = .butt {
        didSet {
            backgroundLayer.lineCap = self.lineCap(from: progressLineCapStyle)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var progressLineWidth: CGFloat = 3 {
        didSet {
            progressLayer.lineWidth = progressLineWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var isShowPercentage: Bool = true { didSet { setNeedsDisplay() } }
    @IBInspectable public var percentageFontSize: CGFloat = 15 { didSet { setNeedsDisplay() } }
    @IBInspectable public var percentageColor: UIColor = kDefaultBlueColor { didSet { setNeedsDisplay() } }

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
        progressLayer.fillColor = UIColor.clear.cgColor
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
    override public func draw(_ rect: CGRect) {
        drawBackground()
        drawProgress()
        
        if isShowPercentage {
            drawText()
        }
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
        let font = UIFont.systemFont(ofSize: percentageFontSize)
        let attributes: [NSAttributedStringKey : Any] = [.font: font, .foregroundColor: percentageColor, .paragraphStyle: paragraphStyle]
        return attributes
    }
    
    private var percentageTextAttributes: [NSAttributedStringKey : Any] {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .right
        let font = UIFont.systemFont(ofSize: percentageFontSize)
        let attributes: [NSAttributedStringKey : Any] = [.font: font, .foregroundColor: percentageColor, .paragraphStyle: paragraphStyle]
        return attributes
    }
    
    private var delta: CGFloat {
        let text = self.text
        let estimateDigitWidth = (percentageFontSize + 3) / 2
        switch text.count {
        case 1: return 0
        case 2: return estimateDigitWidth / 2
        case 3: return estimateDigitWidth
        default: return 0
        }
    }
    
    private var text: String {
        return "\(Int(round(Double(progress * 100))))"
    }
    
    private func drawText() {
        drawPercentageText()
        drawPercentageSymbol()
    }
    
    private func drawPercentageText() {
        let textAttributes = self.percentageTextAttributes
        let maxTextRect = CGRect(x: 0, y: 0, width: bounds.size.width/2.0 + delta, height: bounds.size.height)
        let textRect = text.boundingRect(with: maxTextRect.size, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        let textDrawRect = CGRect(x: maxTextRect.minX,
                                  y: maxTextRect.minY + (maxTextRect.height - textRect.height) * 0.5,
                                  width: maxTextRect.width,
                                  height: textRect.height)
        text.draw(in: textDrawRect, withAttributes: textAttributes)
    }
    
    private func drawPercentageSymbol() {
        let symbol = "%" as NSString
        let symbolAttributes = self.percentageSymbolAttributes
        let maxSymbolRect = CGRect(x: bounds.size.width/2.0 + delta, y: 0, width: bounds.size.width/2.0 - delta, height: bounds.size.height)
        let symbolRect = symbol.boundingRect(with: maxSymbolRect.size, options: .usesLineFragmentOrigin, attributes: symbolAttributes, context: nil)
        let symbolDrawRect = CGRect(x: maxSymbolRect.minX,
                                    y: maxSymbolRect.minY + (maxSymbolRect.height - symbolRect.height) * 0.5,
                                    width: maxSymbolRect.width,
                                    height: symbolRect.height)
        symbol.draw(in: symbolDrawRect, withAttributes: symbolAttributes)
    }
}
