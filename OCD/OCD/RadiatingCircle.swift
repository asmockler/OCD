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

    // MARK: Constants
    fileprivate let ANIMATION_DURATION = 9.0
    fileprivate let SCALE_AMOUNT: CGFloat = 3.0

    // MARK: Properties
    var circles = [CAShapeLayer]()
    fileprivate let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    fileprivate let opacityAnimation = CABasicAnimation(keyPath: "opacity")

    // MARK: Methods required for InterfaceBuilder
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if TARGET_INTERFACE_BUILDER
            for _ in 0..<3 { drawCircle() }
        #endif
        setupAnimations()

        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        #if TARGET_INTERFACE_BUILDER
            for _ in 0..<3 { drawCircle() }
        #endif
        setupAnimations()

        backgroundColor = UIColor.clear
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        let viewCenter = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        for (index, circle) in circles.enumerated() {
            circle.position = viewCenter
            let circleScale = CGFloat(index + 1)
            circle.transform = CATransform3DMakeScale(circleScale, circleScale, 1.0)
        }

        backgroundColor = UIColor.clear
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }


    // MARK: Public Interface
    func startAnimation() {
        perform(#selector(RadiatingCircle.drawCircle), with: self)
        perform(#selector(RadiatingCircle.drawCircle), with: self, afterDelay: 3.0)
        perform(#selector(RadiatingCircle.drawCircle), with: self, afterDelay: 6.0)
    }


    // MARK: Private methods
    @objc private func drawCircle() {
        let smallestFrameLength = min(frame.size.width, frame.size.height)
        let beginningDiameter = smallestFrameLength / SCALE_AMOUNT
        let radius = beginningDiameter > 0 ? beginningDiameter / 2 : 15.0 // Specify a default value for interface builder

        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: 0),
            radius: radius,
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

    fileprivate func setupAnimations() {
        // Set up scale animation
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 3.0
        scaleAnimation.duration = ANIMATION_DURATION
        scaleAnimation.repeatCount = .infinity

        // Set up opacity animation
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = (ANIMATION_DURATION / 2)
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = true
    }

}
