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
    var parentViewController:OnboardingController? = nil
    
    required init?(coder aDecoder: NSCoder) {
        circles = [CAShapeLayer]()
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.blackColor()
        
        drawCircle()
        performSelector(#selector(RadiatingCircles.drawCircle), withObject: self, afterDelay: 3.0)
        performSelector(#selector(RadiatingCircles.drawCircle), withObject: self, afterDelay: 6.0)
    }
    
    func drawCircle () {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(20), startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
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
        opacityAnimation.delegate = self
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = true
        
        shapeLayer.addAnimation(scaleAnimation, forKey: "scale")
        shapeLayer.addAnimation(opacityAnimation, forKey: "opacity")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        circles.first?.removeFromSuperlayer()
//        circles.removeFirst()
//        drawCircle(0.0)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // update current state in GameView
        print("circles touched inside rad")
        self.parentViewController!.circlesTapped()
        
    }
    
}
