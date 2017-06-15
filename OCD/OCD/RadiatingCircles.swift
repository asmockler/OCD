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
        
        self.backgroundColor = UIColor.black
        
        startAnimation()
    }
    
    func startAnimation() {
        perform(#selector(RadiatingCircles.drawCircle), with: self, afterDelay: 1.0)
        perform(#selector(RadiatingCircles.drawCircle), with: self, afterDelay: 4.0)
        perform(#selector(RadiatingCircles.drawCircle), with: self, afterDelay: 7.0)
    }
    
    func reset () {
        for circle in circles {
            circle.removeFromSuperlayer()
        }
    }
    
    func drawCircle () {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: 0),
            radius: CGFloat(20),
            startAngle: CGFloat(0),
            endAngle: (CGFloat.pi * 2),
            clockwise: true
        )
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        circles.append(shapeLayer)
        
        self.layer.addSublayer(shapeLayer)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 3.0
        scaleAnimation.duration = 9.0
        scaleAnimation.repeatCount = .infinity
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 4.5
        opacityAnimation.delegate = self as? CAAnimationDelegate
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = true
        
        shapeLayer.add(scaleAnimation, forKey: "scale")
        shapeLayer.add(opacityAnimation, forKey: "opacity")
    }
}
