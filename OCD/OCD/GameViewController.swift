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
    
    var sentenceNumber:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("game view did load")
                
        let scene = GameScene(size: view.bounds.size)
        scene.parentViewController = self
        scene.sentenceNumber = self.sentenceNumber
        
        let skView = view as! SKView
        
        skView.presentScene(scene)

    }
    
    override func viewDidAppear(animated: Bool) {
        print("Game view did appear")
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
        
}
