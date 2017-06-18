//
//  ViewController.swift
//  OCD
//
//  Created by Andy Mockler on 6/16/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tapToStartLabel: UILabel!
    @IBOutlet weak var radiatingCircles: RadiatingCircle!


    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        tapToStartLabel.setKerning(amount: OCDConstants.Typography.Kerning)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        radiatingCircles.startAnimation()
    }


}
