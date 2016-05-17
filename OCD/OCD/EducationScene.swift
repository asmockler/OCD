//
//  EducationScene.swift
//  OCD
//
//  Created by Dan Morain on 5/15/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import SpriteKit

enum EducationLabelState : CustomStringConvertible {
    case Start, WhenSomeone, JustLikeHaving, ItOnlyGetsWorse, FeelNeedToEngage, SuccessfulTherapy, End
    
    var description: String {
        switch self {
        case .Start:
            return "UH OH! WHAT HAPPENED?\n SWIPE LEFT TO FIND OUT."
        case .WhenSomeone:
            return "When someone has Obsessive Compulsive Disorder, they\n experience obsessive impulsive thoughts that cause them life\n disrupting anxiety.  Everyone has intrusive thoughts sometimes,\n but when you have OCD it is invasive – it won't go away."
        case .JustLikeHaving:
            return "Just like having OCD, the swiping action you were doing to try\n and get rid of the obsessive thought acted as a compulsion. \n Compulsions are repetitive behaviors or thoughts used to get\n rid of an obsession."
        case .ItOnlyGetsWorse:
            return "Just as you tried harder to get rid of the thougths by engaging \n in the \"compulsion\" it only gets worse, which is what happens\n with OCD.  The more you obsess or engage in a compulsion,\n the worse and stronger the obsession gets. "
        case .FeelNeedToEngage:
            return "People with OCD feel the need to engage in compulsions in\n order to get rid of the obsessive thoughts and the accompanying\n paralyzing and life disrupting anxiety they are experiencing."
        case .SuccessfulTherapy:
            return "Through successful therapy and/or medication sufferers learn to\n accept their uncertainties and not engage in their compulsions."
        case .End:
            return "OCD IS NOT AN ADJECTIVE AND SHOULD\n NOT BE USED AS SUCH AS IT IS A\n DEBILITATING MENTAL ILLNESS. BUT\n THERE IS HOPE FOR PEOPLE SUFFERING. \n\n Learn more by visiting iocdf.org"
        }
    }
    
    var nextState: EducationLabelState {
        switch self {
        case .Start:
            return .WhenSomeone
        case .WhenSomeone:
            return .JustLikeHaving
        case .JustLikeHaving:
            return .ItOnlyGetsWorse
        case .ItOnlyGetsWorse:
            return .FeelNeedToEngage
        case .FeelNeedToEngage:
            return .SuccessfulTherapy
        case .SuccessfulTherapy:
            return .End
        default:
            return .End
        }
    }
    
    var prevState: EducationLabelState {
        switch self {
        case .WhenSomeone:
            return .WhenSomeone
        case .JustLikeHaving:
            return .WhenSomeone
        case .ItOnlyGetsWorse:
            return .JustLikeHaving
        case .FeelNeedToEngage:
            return .ItOnlyGetsWorse
        case .SuccessfulTherapy:
            return .FeelNeedToEngage
        case .End:
            return .SuccessfulTherapy
        default:
            return .WhenSomeone
        }
    }
}

class EducationScene: SKScene, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    
    var currentState:EducationLabelState = .Start
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    override func didMoveToView(view: SKView) {
        
        // show "uh oh" on a black screen
        let label = SKLabelNodeMultiline(text: currentState.description)
        label.name = "SKLabelNodeMultiline"
        label.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        label.fontColor = UIColor.whiteColor()
        label.fontSize = 25
        self.addChild(label)
        
        // add gestures
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(EducationScene.updateLabelState(_:)))
        // 4
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
        
    }
    
    func updateLabelState(recognizer: UIGestureRecognizer){
        
        if currentState == .Start {
            // update state
            self.currentState = currentState.nextState
        } else {
            // get the tapped node
            
            // Convert the gesture touch point into a scene touch point
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            // Get the touched node
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            if touchedNode.name == "nextButton" {
                self.currentState = currentState.nextState
            } else if touchedNode.name == "backButton" {
                self.currentState = currentState.prevState
            }
        }
        
        // update label text
        let label = self.childNodeWithName("SKLabelNodeMultiline") as! SKLabelNodeMultiline
        label.text = self.currentState.description
        label.fontSize = 20
        
        print(currentState.hashValue)
        
        // show buttons
        if self.currentState.hashValue >= 1 {
            // add next button
            let nextButton = SKLabelNode()
            nextButton.text = "NEXT >"
            
            nextButton.position = CGPointMake(self.frame.width/1.25, self.frame.height/8)
            nextButton.name = "nextButton"
            self.addChild(nextButton)
        }
        
        if self.currentState.hashValue >= 2 {
            // add back button
            let nextButton = SKLabelNode()
            nextButton.text = "< BACK"
            
            nextButton.position = CGPointMake(self.frame.width/4, self.frame.height/8)
            nextButton.name = "backButton"
            self.addChild(nextButton)
        }
        
        
        
    }
    
}