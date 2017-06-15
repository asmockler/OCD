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
    
    var currentState:EducationLabelState = .start
    
    var sentenceNumber:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateState()
        
        // swipe left to progress
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(EducationalViewController.swipedLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // set timeout if user bails after 2 mins
        Timer.scheduledTimer(timeInterval: 120.0, target:self, selector: #selector(EducationalViewController.closeButtonTapped), userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("edu view did appear")
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func swipedLeft(_ sender:UISwipeGestureRecognizer){
        // update state
        self.currentState = currentState.nextState
        updateState()
        
        // disable swipe
        sender.isEnabled = false
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
                
        // update state
        self.currentState = currentState.nextState
        updateState()
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        // update state
        self.currentState = currentState.prevState
        updateState()
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        // segue back to Onboarding
        self.dismiss(animated: true, completion: nil)
    }
        
    func updateState() {
        
        let attributedString = NSMutableAttributedString(string: self.currentState.description)
        

        

        
        
        switch self.currentState {
            
        case .start:
            // set label to .Start
            educationalLabel.text = currentState.description
            
            let attributedStringLength = self.currentState.description.characters.count
            
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(5.0), range: NSRange(location: 0, length: attributedStringLength))
            
            // hide all buttons and progress circles
            backButton.isHidden = true
            nextButton.isHidden = true
            closeButton.isHidden = true
            exitButton.isHidden = true
            progressCircles.isHidden = true
            
            break
            
        case .whenSomeone:
            // show progressCircles, nextButton, closeButton
            progressCircles.isHidden = false
            nextButton.isHidden = false
            closeButton.isHidden = false
            
            // hide backButton
            backButton.isHidden = true
            
            // set progressCircles to cirlces-1
            let image = UIImage(named: "circles-1")
            progressCircles.setImage(image, for: UIControlState())
            
            break
            
        case .justLikeHaving:
            // show back button
            backButton.isHidden = false
            
            // set progressCircles to circles-2
            let image = UIImage(named: "circles-2")
            progressCircles.setImage(image, for: UIControlState())
            
            break
            
        case .itOnlyGetsWorse:
            // set progress circles to circles-3
            let image = UIImage(named: "circles-3")
            progressCircles.setImage(image, for: UIControlState())
            
            break
            
        case .feelNeedToEngage:
            // set progress circles to circles-4
            let image = UIImage(named: "circles-4")
            progressCircles.setImage(image, for: UIControlState())
            
            break
            
        case .successfulTherapy:
            // set progress circles to circles-5
            let image = UIImage(named: "circles-5")
            progressCircles.setImage(image, for: UIControlState())
            
            break
            
        case .end:
            // hide backButton, nextButton, progressCircles
            backButton.isHidden = true
            nextButton.isHidden = true
            progressCircles.isHidden = true
            
            // center educationalLabel text
            educationalLabel.textAlignment = .center
            
            // show exitButton
            exitButton.isHidden = false
            
            let attributedStringLength = self.currentState.description.characters.count
            
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(5.0), range: NSRange(location: 0, length: attributedStringLength))
            
            
            break
        }
        
        // update text
        UIView.transition(with: educationalLabel, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.educationalLabel.attributedText = attributedString
            }, completion: nil)

    }
    
    
}

enum EducationLabelState : CustomStringConvertible {
    case start, whenSomeone, justLikeHaving, itOnlyGetsWorse, feelNeedToEngage, successfulTherapy, end
    
    var description: String {
        switch self {
        case .start:
            return "UH OH! WHAT HAPPENED? \nSWIPE LEFT TO FIND OUT."
        case .whenSomeone:
            return "When someone has Obsessive Compulsive Disorder, they \nexperience obsessive impulsive thoughts that cause them life \ndisrupting anxiety.  Everyone has intrusive thoughts sometimes, \nbut when you have OCD it is invasive – it won't go away."
        case .justLikeHaving:
            return "Just like having OCD, the swiping action you were doing to try \nand get rid of the obsessive thought acted as a compulsion. \nCompulsions are repetitive behaviors or thoughts used to get \nrid of an obsession."
        case .itOnlyGetsWorse:
            return "Just as you tried harder to get rid of the thoughts by engaging \nin the \"compulsion\" it only gets worse, which is what happens \nwith OCD.  The more you obsess or engage in a compulsion, \nthe worse and stronger the obsession gets. "
        case .feelNeedToEngage:
            return "People with OCD feel the need to engage in compulsions in \norder to get rid of the obsessive thoughts and the accompanying \nparalyzing and life disrupting anxiety they are experiencing."
        case .successfulTherapy:
            return "Through successful therapy and/or medication sufferers learn to \naccept their uncertainties and not engage in their compulsions."
        case .end:
            return "OCD IS NOT AN ADJECTIVE AND SHOULD \nNOT BE USED AS SUCH AS IT IS A \nDEBILITATING MENTAL ILLNESS. BUT \nTHERE IS HOPE FOR PEOPLE SUFFERING. \n\nLearn more by visiting iocdf.org"
        }
    }
    
    var nextState: EducationLabelState {
        switch self {
        case .start:
            return .whenSomeone
        case .whenSomeone:
            return .justLikeHaving
        case .justLikeHaving:
            return .itOnlyGetsWorse
        case .itOnlyGetsWorse:
            return .feelNeedToEngage
        case .feelNeedToEngage:
            return .successfulTherapy
        case .successfulTherapy:
            return .end
        default:
            return .end
        }
    }
    
    var prevState: EducationLabelState {
        switch self {
        case .whenSomeone:
            return .whenSomeone
        case .justLikeHaving:
            return .whenSomeone
        case .itOnlyGetsWorse:
            return .justLikeHaving
        case .feelNeedToEngage:
            return .itOnlyGetsWorse
        case .successfulTherapy:
            return .feelNeedToEngage
        case .end:
            return .successfulTherapy
        default:
            return .whenSomeone
        }
    }
}
