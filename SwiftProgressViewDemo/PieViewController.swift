//
//  PieViewController.swift
//  SwiftProgressViewDemo
//
//  Created by Derek on 31/10/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit
import SwiftProgressView

class PieViewController: UIViewController {

    @IBOutlet weak var progressView: ProgressPieView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var startOrEndButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStartOrEndButton()
    }
    
    func updateStartOrEndButton() {
        let isOver = progressView.isOver
        startOrEndButton.setTitle(isOver ? "Start" : "End", for: .normal)
    }
    
    @IBAction func startOrEndProgress(_ sender: UIButton) {
        progressView.isOver = !progressView.isOver
        updateStartOrEndButton()
    }
    
    @IBAction func animate(_ sender: UIButton) {
        var progress: CGFloat = progressView.progress
        if progress == 1.0 {
            progress = 0.0
        } else {
            progress = 1.0
        }
        progressView.setProgress(progress, animated: true)
        progressSlider.setValue(Float(progress), animated: true)
    }

    @IBAction func progressChanged(_ sender: UISlider) {
        progressView.setProgress(CGFloat(sender.value), animated: false)
    }
    
    @IBAction func circleLineWidthChanged(_ sender: UISlider) {
        progressView.circleLineWidth = CGFloat(sender.value)
    }
    
    @IBAction func spacingChanged(_ sender: UISlider) {
        progressView.spacing = CGFloat(sender.value)
    }
    
    @IBAction func changeCircleColor(_ sender: UIButton) {
        progressView.circleColor = sender.backgroundColor!
    }
    
    @IBAction func changeProgressColor(_ sender: UIButton) {
        progressView.progressColor = sender.backgroundColor!
    }
}
