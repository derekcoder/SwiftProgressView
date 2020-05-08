//
//  ProgressRingView.swift
//  Test
//
//  Created by Derek on 31/10/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

public class ProgressRingView: ProgressView {
    private var progressLayer: CAShapeLayer!
    
    override public var progressColor: UIColor {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
            setNeedsDisplay()
        }
    }
    
    public var progressLineCapStyle: CGLineCap = .butt {
        didSet {
            backgroundLayer.lineCap = convertToCAShapeLayerLineCap(self.lineCap(from: progressLineCapStyle))
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
    @IBInspectable public var percentageColor: UIColor = Constants.Color.blue { didSet { setNeedsDisplay() } }

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
        backgroundLayer.lineCap = CAShapeLayerLineCap.round
        backgroundLayer.lineWidth = circleLineWidth
        layer.addSublayer(backgroundLayer)
        
        progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.lineCap = convertToCAShapeLayerLineCap(self.lineCap(from: progressLineCapStyle))
        progressLayer.lineWidth = progressLineWidth
        layer.addSublayer(progressLayer)
    }
    
    private func lineCap(from capStyle: CGLineCap) -> String {
        switch capStyle {
        case .butt: return convertFromCAShapeLayerLineCap(CAShapeLayerLineCap.butt)
        case .round: return convertFromCAShapeLayerLineCap(CAShapeLayerLineCap.round)
        case .square: return convertFromCAShapeLayerLineCap(CAShapeLayerLineCap.square)
        @unknown default:
            print("Unknown line cap used, using square: \(capStyle)")
            return convertFromCAShapeLayerLineCap(CAShapeLayerLineCap.square)
        }
    }
    
    // MARK: - Public
    public override func setProgress(_ progress: CGFloat, animated: Bool) {
        guard !isOver else { return }
        guard self.progress != progress else { return }
        
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
                displayLink!.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
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
        progressLayer.opacity = isOver ? 0 : 1
        if isOver {
            drawIndicator()
        }

        if isShowPercentage && !isOver {
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
        let font = UIFont.systemFont(ofSize: percentageFontSize)
        let textAttributes = self.textAttributes(withFont: font, alignment: .right, foregroundColor: percentageColor)
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
        let font = UIFont.systemFont(ofSize: percentageFontSize)
        let symbolAttributes = self.textAttributes(withFont: font, alignment: .left, foregroundColor: percentageColor)
        let maxSymbolRect = CGRect(x: bounds.size.width/2.0 + delta, y: 0, width: bounds.size.width/2.0 - delta, height: bounds.size.height)
        let symbolRect = symbol.boundingRect(with: maxSymbolRect.size, options: .usesLineFragmentOrigin, attributes: symbolAttributes, context: nil)
        let symbolDrawRect = CGRect(x: maxSymbolRect.minX,
                                    y: maxSymbolRect.minY + (maxSymbolRect.height - symbolRect.height) * 0.5,
                                    width: maxSymbolRect.width,
                                    height: symbolRect.height)
        symbol.draw(in: symbolDrawRect, withAttributes: symbolAttributes)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCAShapeLayerLineCap(_ input: CAShapeLayerLineCap) -> String {
	return input.rawValue
}
