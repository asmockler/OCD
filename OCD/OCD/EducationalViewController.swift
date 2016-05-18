//
//  EducationalViewController.swift
//  OCD
//
//  Created by Dan Morain on 5/17/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import UIKit

class EducationalViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var educationalLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var progressCircles: UIButton!
    
    var currentState:EducationLabelState = .Start
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // set label to .Start
        educationalLabel.text = currentState.description
        
        // hide all buttons and progress circles
        backButton.hidden = true
        nextButton.hidden = true
        closeButton.hidden = true
        exitButton.hidden = true
        progressCircles.hidden = true
        
        // swipe left to progress
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(EducationalViewController.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)

        
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        // update state
        self.currentState = currentState.nextState
        updateState()
        
        // disable swipe
        sender.enabled = false
    }
    
    
    @IBAction func nextButtonTapped(sender: UIButton) {
                
        // update state
        self.currentState = currentState.nextState
        updateState()
        
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        
        // update state
        self.currentState = currentState.prevState
        updateState()
        
    }
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        
        // seque back to Onboarding
        performSegueWithIdentifier("showOnboarding", sender: self)
        
    }
    
    func updateState() {
        
        // update text
        UIView.transitionWithView(educationalLabel, duration: 0.5, options: [.TransitionCrossDissolve], animations: {
            self.educationalLabel.text = self.currentState.description
            }, completion: nil)
        
        switch self.currentState {
        case .WhenSomeone:
            // show progressCircles, nextButton, closeButton
            progressCircles.hidden = false
            nextButton.hidden = false
            closeButton.hidden = false
            
            // hide backButton
            backButton.hidden = true
            
            // set progressCircles to cirlces-1
            let image = UIImage(named: "circles-1")
            progressCircles.setImage(image, forState: .Normal)
            
            break
            
        case .JustLikeHaving:
            // show back button
            backButton.hidden = false
            
            // set progressCircles to circles-2
            let image = UIImage(named: "circles-2")
            progressCircles.setImage(image, forState: .Normal)
            
            break
            
        case .ItOnlyGetsWorse:
            // set progress circles to circles-3
            let image = UIImage(named: "circles-3")
            progressCircles.setImage(image, forState: .Normal)
            
            break
            
        case .FeelNeedToEngage:
            // set progress circles to circles-4
            let image = UIImage(named: "circles-4")
            progressCircles.setImage(image, forState: .Normal)
            
            break
            
        case .SuccessfulTherapy:
            // set progress circles to circles-5
            let image = UIImage(named: "circles-5")
            progressCircles.setImage(image, forState: .Normal)
            
            break
            
        case .End:
            // hide backButton, nextButton, progressCircles
            backButton.hidden = true
            nextButton.hidden = true
            progressCircles.hidden = true
            
            // show exitButton
            exitButton.hidden = false
            
            
            break
        default: break
            
        }

    }
    
    
}

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
            return "Just as you tried harder to get rid of the thoughts by engaging \n in the \"compulsion\" it only gets worse, which is what happens\n with OCD.  The more you obsess or engage in a compulsion,\n the worse and stronger the obsession gets. "
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