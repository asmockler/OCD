//
//  OnboardingController.swift
//  OCD
//
//  Created by Andy on 4/24/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import UIKit

enum OnboardingLabelState : CustomStringConvertible {
    case tapToStart, keepScreenClear, swipeLeftAndRight, tapToPlay, moveToGameController, moveToEducationController
    
    var description: String {
        switch self {
        case .tapToStart:
            return "TAP TO START"
        case .keepScreenClear:
            return "Try and keep the screen clear of\nintrusive thoughts."
        case .swipeLeftAndRight:
            return "Swipe them off the screen\nleft and right."
        case .tapToPlay:
            return "TAP TO PLAY"
        case .moveToGameController:
            return ""
        case .moveToEducationController:
            return ""
        }
    }
    
    var nextState: OnboardingLabelState {
        switch self {
        case .tapToStart:
            return .keepScreenClear
        case .keepScreenClear:
            return .swipeLeftAndRight
        case .swipeLeftAndRight:
            return .tapToPlay
        case .tapToPlay:
            return .moveToGameController
        case .moveToGameController:
            return .moveToEducationController
        case .moveToEducationController:
            return .tapToStart
        }
    }
}

class OnboardingController : UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var label: UILabel!
    var currentState:OnboardingLabelState = .tapToStart
    
    @IBOutlet weak var radiatingCircles: RadiatingCircles!
    
    @IBOutlet weak var reviewButton: UIButton!
    
    var touchesEnabled = true
    
    var sentenceNumber:Int = 5
    
    
    // MARK: Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("onboard view did load")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("onboard view did appear")
        
        updateState()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.touchesEnabled {
            self.currentState = currentState.nextState
            updateState()
        }
        
    }
        
    func moveToGameController() {
        // call segue manually with identifier
        performSegue(withIdentifier: "gameViewSegue", sender: self)
    }
    

    @IBAction func reviewButtonTapped(_ sender: UIButton) {
        
        self.currentState = .keepScreenClear
        updateState()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameViewSegue" {
            
            if self.sentenceNumber < 5 {
                self.sentenceNumber = self.sentenceNumber + 1
            } else {
                self.sentenceNumber = 1
            }
            
            // pass sentenceNumber
            let viewController = segue.destination as! GameViewController
            viewController.sentenceNumber = self.sentenceNumber
        }
    }
    
    
    func updateState() {
        
        let attributedString = NSMutableAttributedString(string: self.currentState.description.uppercased())
        
        let attributedStringLength = self.currentState.description.characters.count
        
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(5.0), range: NSRange(location: 0, length: attributedStringLength))
        
        
        UIView.transition(with: label, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.label.attributedText = attributedString
        }, completion: nil)
        
        switch self.currentState {
            
        case .tapToStart:
            // show label, radiatingCirlces
            label.isHidden = false
            label.textColor = UIColor.white
            radiatingCircles.isHidden = false
            radiatingCircles.reset()
            radiatingCircles.startAnimation()
            
            // hide reviewButton
            reviewButton.isHidden = true
            
            // enable touches
            self.touchesEnabled = true
            
            break
            
        case .keepScreenClear:
            
            // hide radiatingCircles and reviewInstructions
            radiatingCircles.isHidden = true
            reviewButton.isHidden = true
            
            // start timer
            _ = Timer.scheduledTimer(timeInterval: 3.0, target:self, selector: #selector(OnboardingController.updateState), userInfo: nil, repeats: false)
            
            // change state
            self.currentState = self.currentState.nextState
            
            // disable touches until timer returns
            self.touchesEnabled = false
            
            break
            
        case .swipeLeftAndRight:
            
            // start timer
            _ = Timer.scheduledTimer(timeInterval: 3.0, target:self, selector: #selector(OnboardingController.updateState), userInfo: nil, repeats: false)
            
            // change state
            self.currentState = self.currentState.nextState
            
            break
            
            
        case .tapToPlay:
            // show radidiatingCircles and reviewButton
            radiatingCircles.isHidden = false
            reviewButton.isHidden = false
            
            // enable touches
            self.touchesEnabled = true
            
            break
        
        case .moveToGameController:
            // disable touches
            self.touchesEnabled = false
            
            // hide radiatingCircles, reviewButton
            radiatingCircles.isHidden = true
            reviewButton.isHidden = true
            
            // change state
            self.currentState = self.currentState.nextState
            moveToGameController()
            break
            
        case .moveToEducationController:
            
            self.currentState = self.currentState.nextState
            self.performSegue(withIdentifier: "showEducationalSeries", sender: self)
            
            break
        }
    }

}
