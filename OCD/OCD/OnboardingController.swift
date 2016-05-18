//
//  OnboardingController.swift
//  OCD
//
//  Created by Andy on 4/24/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import UIKit

enum OnboardingLabelState : CustomStringConvertible {
    case TapToStart, KeepScreenClear, SwipeLeftAndRight, TapToPlay, MoveToGameController, MoveToEducationController
    
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
        case .MoveToEducationController:
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
            return .MoveToEducationController
        case .MoveToEducationController:
            return .TapToStart
        }
    }
}

class OnboardingController : UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var label: UILabel!
    var currentState:OnboardingLabelState = .TapToStart
    
    @IBOutlet weak var radiatingCircles: RadiatingCircles!
    
    @IBOutlet weak var reviewButton: UIButton!
    
    var touchesEnabled = true
    
    var sentenceNumber:Int = 5
    
    
    // MARK: Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("onboard view did load")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("onboard view did appear")
        
        updateState()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.touchesEnabled {
            self.currentState = currentState.nextState
            updateState()
        }
        
    }
        
    func moveToGameController() {
        // call segue manually with identifier
        performSegueWithIdentifier("gameViewSegue", sender: self)
    }
    

    @IBAction func reviewButtonTapped(sender: UIButton) {
        
        self.currentState = .KeepScreenClear
        updateState()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameViewSegue" {
            
            if self.sentenceNumber < 5 {
                self.sentenceNumber = self.sentenceNumber + 1
            } else {
                self.sentenceNumber = 1
            }
            
            // pass sentenceNumber
            let viewController = segue.destinationViewController as! GameViewController
            viewController.sentenceNumber = self.sentenceNumber
        }
    }
    
    
    func updateState() {
        
        print("currentState: \(self.currentState.hashValue)")
        
        UIView.transitionWithView(label, duration: 0.5, options: [.TransitionCrossDissolve], animations: {
            self.label.text = self.currentState.description.uppercaseString
            }, completion: nil)
        
        
        switch self.currentState {
            
        case .TapToStart:
            // hide reviewButton
            reviewButton.hidden = true
            
            // enable touches
            self.touchesEnabled = true
            
            radiatingCircles.startAnimation()
            
            break
            
        case .KeepScreenClear:
            
            // hide radiatingCircles and reviewInstructions
            radiatingCircles.hidden = true
            reviewButton.hidden = true
            
            // start timer
            var timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target:self, selector: #selector(OnboardingController.updateState), userInfo: nil, repeats: false)
            
            // change state
            self.currentState = self.currentState.nextState
            
            // disable touches until timer returns
            self.touchesEnabled = false
            
            break
            
        case .SwipeLeftAndRight:
            
            // start timer
            var timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target:self, selector: #selector(OnboardingController.updateState), userInfo: nil, repeats: false)
            
            // change state
            self.currentState = self.currentState.nextState
            
            break
            
            
        case .TapToPlay:
            // show radidiatingCircles and reviewButton
            radiatingCircles.hidden = false
            reviewButton.hidden = false
            
            // enable touches
            self.touchesEnabled = true
            
            break
        
        case .MoveToGameController:
            // disable touches
            self.touchesEnabled = false
            
            // change state
            self.currentState = self.currentState.nextState
            moveToGameController()
            break
            
        case .MoveToEducationController:
            
            self.currentState = self.currentState.nextState
            self.performSegueWithIdentifier("showEducationalSeries", sender: self)
            
            break
        }
    }

}