//
//  GameViewController.swift
//  OCD
//
//  Created by Andy on 4/14/16.
//  Copyright (c) 2016 Andy Mockler. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        
        // for debugging
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)

    }


    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}