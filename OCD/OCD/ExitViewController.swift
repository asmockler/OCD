//
//  EducationFinalView.swift
//  OCD
//
//  Created by Andy Mockler on 6/25/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit

class ExitViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var radiatingCircles: RadiatingCircle!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        radiatingCircles.startAnimation()
    }

}
