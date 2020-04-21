//
//  CircularProgressView.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 14.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {

    private var progressLyr = CAShapeLayer()
    private var trackLyr = CAShapeLayer()
    
    var progressClr = UIColor.white {
       didSet {
          progressLyr.strokeColor = progressClr.cgColor
       }
    }
    var trackClr = UIColor.white {
       didSet {
          trackLyr.strokeColor = trackClr.cgColor
       }
    }
    
    var lineWidth: CGFloat = 1 {
       didSet {
            trackLyr.lineWidth = lineWidth
            progressLyr.lineWidth = lineWidth
       }
    }
    
    private var prevValue = Float(0.0)
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
//       makeCircularPath()
    }
    
    override func draw(_ rect: CGRect) {
        makeCircularPath()
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = prevValue
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLyr.strokeEnd = CGFloat(value)
        progressLyr.add(animation, forKey: "animateprogress")
        
        prevValue = value
    }
    
    func makeCircularPath() {
       self.backgroundColor = UIColor.clear
       self.layer.cornerRadius = self.frame.size.width/2
       let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
       trackLyr.path = circlePath.cgPath
       trackLyr.fillColor = UIColor.clear.cgColor
       trackLyr.strokeColor = trackClr.cgColor
//       trackLyr.lineWidth = 1.0
       trackLyr.strokeEnd = 1.0
       layer.addSublayer(trackLyr)
       progressLyr.path = circlePath.cgPath
       progressLyr.fillColor = UIColor.clear.cgColor
       progressLyr.strokeColor = progressClr.cgColor
//       progressLyr.lineWidth = 2.0
       progressLyr.strokeEnd = 0.0
       layer.addSublayer(progressLyr)
    }
}
