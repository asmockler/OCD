//
//  OnboardingController.swift
//  OCD
//
//  Created by Andy on 4/24/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import UIKit

enum OnboardingLabelState : CustomStringConvertible {
    case TapToStart, KeepScreenClear, SwipeLeftAndRight, TapToPlay, MoveToGameController
    
    var description: String {
        switch self {
        case .TapToStart:
            return "TAP TO START"
        case .KeepScreenClear:
            return "Try and keep the screen clear of\nintrusive thoughts."
        case .SwipeLeftAndRight:
            return "Swipe them off the screen\nleft and right."
        case .TapToPlay:
            return "TAP TO PLAY"
        case .MoveToGameController:
            return ""
        }
    }
    
    var nextState: OnboardingLabelState {
        switch self {
        case .TapToStart:
            return .KeepScreenClear
        case .KeepScreenClear:
            return .SwipeLeftAndRight
        case .SwipeLeftAndRight:
            return .TapToPlay
        case .TapToPlay:
            return .MoveToGameController
        case .MoveToGameController:
            return .MoveToGameController
        }
    }
}

class OnboardingController : UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var label: UILabel!
    var currentState:OnboardingLabelState = .TapToStart
    
    @IBOutlet weak var radiatingCircles: RadiatingCircles!
    
    // MARK: Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("currentState: \(self.currentState.hashValue)")
        
        // Set the initial label text
        label.text = currentState.description
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.currentState = currentState.nextState
        print("currentState: \(self.currentState.hashValue)")
        updateState()
        
        if (self.currentState == .MoveToGameController) {
            moveToGameController()
        } else {
            UIView.transitionWithView(label, duration: 0.5, options: [.TransitionCrossDissolve], animations: {
                self.label.text = self.currentState.description.uppercaseString
                }, completion: nil)
        }
    }
        
    func moveToGameController() {
        // call segue manually with identifier
        performSegueWithIdentifier("gameViewSegue", sender: self)
    }
    
    func updateState() {

        switch self.currentState {
        case .KeepScreenClear:
            // hide radiatingCircles
            radiatingCircles.hidden = true
            break
            
        case .TapToPlay:
            // show radidiatingCircles
            radiatingCircles.hidden = false
            break
            
        default:
            break
        }
        
        
    }

}