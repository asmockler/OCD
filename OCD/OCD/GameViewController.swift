//
//  GameViewController.swift
//  OCD
//
//  Created by Andy Mockler on 6/18/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    // MARK: Properties
    var sentenceNumber: Int = 1
    var scene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        scene = GameScene(size: view.bounds.size)
        scene?.parentViewController = self

        (view as! SKView).presentScene(scene)
    }

    func moveToEducationView() {
        performSegue(withIdentifier: "moveToEducationView", sender: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        // Tear down scene
        scene?.removeAllChildren()
        scene?.removeAllActions()
        scene?.removeFromParent()
        scene?.view?.presentScene(nil)
    }
}
