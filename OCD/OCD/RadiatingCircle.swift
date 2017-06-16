//
//  RadiatingCircle.swift
//  OCD
//
//  Created by Andy Mockler on 6/16/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit
import os.log

@IBDesignable class RadiatingCircle: UIView {

    // MARK: Properties
    var circles = [CAShapeLayer]()
    fileprivate let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    fileprivate let opacityAnimation = CABasicAnimation(keyPath: "opacity")

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startAnimation()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        let viewCenter = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        for (index, circle) in circles.enumerated() {
            circle.position = viewCenter
            let circleScale = CGFloat(index + 1)
            circle.transform = CATransform3DMakeScale(circleScale, circleScale, 1.0)
        }
    }

    // MARK: Private Methods
    fileprivate func startAnimation() {
        #if TARGET_INTERFACE_BUILDER
            for _ in 0..<3 { drawCircle() }
        #endif

        let animationDuration = 9.0

        // Set up scale animation
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 3.0
        scaleAnimation.duration = animationDuration
        scaleAnimation.repeatCount = .infinity

        // Set up opacity animation
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = (animationDuration / 2)
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = true

        perform(#selector(RadiatingCircle.drawCircle), with: self, afterDelay: 1.0)
        perform(#selector(RadiatingCircle.drawCircle), with: self, afterDelay: 4.0)
        perform(#selector(RadiatingCircle.drawCircle), with: self, afterDelay: 7.0)
    }

    @objc private func drawCircle() {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: 0),
            radius: 20.0,
            startAngle: 0.0,
            endAngle: (CGFloat.pi * 2),
            clockwise: true
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)

        shapeLayer.add(scaleAnimation, forKey: "scale")
        shapeLayer.add(opacityAnimation, forKey: "opacity")

        circles.append(shapeLayer)
        layer.addSublayer(shapeLayer)
    }

}





















