//
//  EducationScene.swift
//  OCD
//
//  Created by Dan Morain on 5/15/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import SpriteKit

class EducationScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        // show "uh oh" on a black screen
        let label = SKLabelNodeMultiline(text: "UH OH! WHAT HAPPENED?\n SWIPE LEFT TO FIND OUT.")
        label.name = "SKLabelNodeMultiline"
        label.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        label.fontColor = UIColor.whiteColor()
        label.fontSize = 16
        self.addChild(label)
        
        // add gestures
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(EducationScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swiped left")
        let label = self.childNodeWithName("SKLabelNodeMultiline") as! SKLabelNodeMultiline
        label.text = "When someone has Obsessive Compulsive Disorder they\n experience obsessive thoughts that cause them life\n disrupting anxiety. Everyone has intrusive thoughts sometimes,\n but when you have OCD it is invasive – it won't go away."
    }
    
    
}