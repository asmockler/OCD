//
//  InstructionsViewController.swift
//  OCD
//
//  Created by Andy Mockler on 6/17/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var topInstructionLabel: UILabel!
    @IBOutlet weak var bottomInstructionLabel: UILabel!
    @IBOutlet weak var radiatingCircles: RadiatingCircle!
    @IBOutlet var advanceScreenTapGesture: UITapGestureRecognizer!


    override func viewDidLoad() {
        super.viewDidLoad()

        topInstructionLabel.setKerning(amount: OCDConstants.Typography.Kerning)
        topInstructionLabel.alpha = 0.0
        bottomInstructionLabel.setKerning(amount: OCDConstants.Typography.Kerning)
        bottomInstructionLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let labelAnimationDuration = 5.0
        let oneRelativeSecond = 1 / labelAnimationDuration

        // Fade in the instructions
        UIView.animateKeyframes(withDuration: labelAnimationDuration, delay: 0.0, options: UIViewKeyframeAnimationOptions(), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: oneRelativeSecond, animations: {
                self.topInstructionLabel.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: oneRelativeSecond, animations: {
                self.bottomInstructionLabel.alpha = 1.0
            })
        }, completion: nil)

        // Start circles animation to prompt a tap. This isn't a part of the above
        // keyframes to keep dealing with relative times a bit more sane.
        DispatchQueue.main.asyncAfter(deadline: .now() + (labelAnimationDuration - 1), execute: {
            self.radiatingCircles.startAnimation()
            self.advanceScreenTapGesture.isEnabled = true
        })
    }

}
