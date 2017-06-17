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

    override func viewDidLoad() {
        super.viewDidLoad()

        tapToStartLabel.setKerning(amount: 3.0)
    }

}

