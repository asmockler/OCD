//
//  RadiatingCircles.swift
//  OCD
//
//  Created by Andy on 4/28/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import UIKit

class RadiatingCircles : UIView {
    var circles:[CAShapeLayer]
    
    required init?(coder aDecoder: NSCoder) {
        circles = [CAShapeLayer]()
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.blackColor()
        
        drawCircle(0.0)
        drawCircle(2.0)
    }
    
    func drawCircle (offset: CFTimeInterval) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.lineWidth = 1.0
        
        circles.append(shapeLayer)
        
        self.layer.addSublayer(shapeLayer)
        
        let scaleAnimation = CABasicAnimation(keyPath: "radius")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 2.0
        scaleAnimation.duration = 4.0
        scaleAnimation.repeatCount = .infinity
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 4.0
        opacityAnimation.delegate = self
        opacityAnimation.repeatCount = .infinity
        
        shapeLayer.addAnimation(scaleAnimation, forKey: "radius")
        shapeLayer.addAnimation(opacityAnimation, forKey: "opacity")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        circles.first?.removeFromSuperlayer()
//        circles.removeFirst()
//        drawCircle(0.0)
    }
    
}
