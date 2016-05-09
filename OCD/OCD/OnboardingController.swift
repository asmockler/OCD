//
//  OnboardingController.swift
//  OCD
//
//  Created by Andy on 4/24/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import UIKit

enum OnboardingLabelState : CustomStringConvertible {
    case TapToStart, KeepScreenClear, SwipeLeftAndRight, MoveToGameController
    
    var description: String {
        switch self {
        case .TapToStart:
            return "TAP TO START"
        case .KeepScreenClear:
            return "Try to keep the screen clear of intrusive thoughts,"
        case .SwipeLeftAndRight:
            return "by swiping them left and right."
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
            return .MoveToGameController
        case .MoveToGameController:
            return .MoveToGameController
        }
    }
}

class OnboardingController : UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var label: UILabel!
    var currentState:OnboardingLabelState = .TapToStart
    
    // MARK: Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the initial label text
        label.text = currentState.description
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Actions
    @IBAction func labelWasTapped(sender: UITapGestureRecognizer) {
        self.currentState = currentState.nextState
        
        if (self.currentState == .MoveToGameController) {
            moveToGameController()
        } else {
            UIView.transitionWithView(label, duration: 0.5, options: [.TransitionCrossDissolve], animations: {
                self.label.text = self.currentState.description
                }, completion: nil)
        }
    }
    
    func moveToGameController() {
//        let controller = GameViewController()
        presentViewController(GameViewController(), animated: true, completion: nil)
        
    }
}