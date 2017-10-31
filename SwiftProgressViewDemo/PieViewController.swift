//
//  PieViewController.swift
//  SwiftProgressViewDemo
//
//  Created by Julie on 31/10/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit
import SwiftProgressView

class PieViewController: UIViewController {

    @IBOutlet weak var progressView: ProgressPieView!
    
    @IBAction func progressChanged(_ sender: UISlider) {
        progressView.setProgress(CGFloat(sender.value), animated: false)
    }
    
    @IBAction func circleLineWidthChanged(_ sender: UISlider) {
        progressView.circleLineWidth = CGFloat(sender.value)
    }
    
    @IBAction func changeCircleColor(_ sender: UIButton) {
        progressView.circleColor = sender.backgroundColor!
    }
    
    @IBAction func changeProgressColor(_ sender: UIButton) {
        progressView.progressColor = sender.backgroundColor!
    }
}
