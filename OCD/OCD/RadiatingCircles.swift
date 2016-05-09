//
//  RadiatingCircles.swift
//  OCD
//
//  Created by Andy on 4/28/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import UIKit

class RadiatingCircles : UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        
        self.layer.addSublayer(shapeLayer)
    }
    
}
