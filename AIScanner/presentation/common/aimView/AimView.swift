//
//  AimView.swift
//  AIScanner
//
//  Created by Alexandr Mikhailov on 04.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class AimView: UIView {
    
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var plusStrokeWidth: CGFloat = 5
    @IBInspectable var cornerStrokeWidth: CGFloat = 5
    @IBInspectable var plusWidth: CGFloat = 20
    @IBInspectable var cornerWidth: CGFloat = 20
    
    private var halfWidth: CGFloat {
        return width / 2
    }
    
    private var halfHeight: CGFloat {
        return height / 2
    }
    
    private var height: CGFloat {
        return bounds.height
    }
    
    private var width: CGFloat {
        return bounds.width
    }
    
    override func draw(_ rect: CGRect) {
        fillColor.setStroke()
        
        drawPlus()
        drawCorners()
    }
    
    private func drawPlus() {
        let plusPath = UIBezierPath()
        let halfPlusWidth = plusWidth / 2
        
        plusPath.lineWidth = plusStrokeWidth
        
        plusPath.addLineBetweenPoints(
            first: CGPoint(
                x: halfWidth - halfPlusWidth,
                y: halfHeight),
            second: CGPoint(
                x: halfWidth + halfPlusWidth,
                y: halfHeight))
        
       plusPath.addLineBetweenPoints(
           first: CGPoint(
               x: halfWidth,
               y: halfHeight - halfPlusWidth),
           second: CGPoint(
               x: halfWidth,
               y: halfHeight + halfPlusWidth))
        
        
        plusPath.stroke()
    }
    
    func drawCorners() {
        let cornerPath = UIBezierPath()
        cornerPath.lineWidth = cornerStrokeWidth
        
        cornerPath.addCorner(
            first: CGPoint(
                x: 0,
                y: cornerWidth),
            second: CGPoint(
                x: 0,
                y: 0),
            third: CGPoint(
                x: cornerWidth,
                y: 0))
        
        cornerPath.addCorner(
            first: CGPoint(
                x: width - cornerWidth,
                y: 0),
            second: CGPoint(
                x: width,
                y: 0),
            third: CGPoint(
                x: width,
                y: cornerWidth))
        
        cornerPath.addCorner(
            first: CGPoint(
                x: width - cornerWidth,
                y: height),
            second: CGPoint(
                x: width,
                y: height),
            third: CGPoint(
                x: width,
                y: height - cornerWidth))
        
        cornerPath.addCorner(
            first: CGPoint(
                x: cornerWidth,
                y: height),
            second: CGPoint(
                x: 0,
                y: height),
            third: CGPoint(
                x: 0,
                y: height - cornerWidth))
        
        cornerPath.stroke()
    }
}

extension UIBezierPath {
    func addLineBetweenPoints(first: CGPoint, second: CGPoint) {
        move(to: first)
        addLine(to: second)
    }
    
    func addCorner(first: CGPoint, second: CGPoint, third: CGPoint) {
        move(to: first)
        
        addLine(to: second)
        addLine(to: third)
    }
}
