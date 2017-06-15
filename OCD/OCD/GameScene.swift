//
//  GameScene.swift
//  OCD
//
//  Created by Andy on 4/14/16.
//  Copyright (c) 2016 Andy Mockler. All rights reserved.
//

import SpriteKit
import QuartzCore
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Properties
    
    var sentenceNumber:Int = 1
    var parentViewController:GameViewController? = nil
    
    
    let SWIPE_THRESHOLD:CGFloat = 1500
    let NODE_BEING_DISMISSED = "node being dismissed"
    var currentGameVelocity:CGFloat = 25.0
    var currentScaleFactor:CGFloat = 1.1
    var waitAction:SKAction?
    
    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0
    var bottomY: CGFloat = 0.0
    var sentenceHeight: CGFloat?
    
    var selectedNode: Sentence?
    var nodeScale: CGFloat?
    var releaseVector: CGVector?
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    var positionWhenTouched: CGPoint?
    
    var shaderMove:SKShader?
    var shaderTwirl:SKShader?
    
    var filterIsAnimating = false
    var currentFilterValue = 1
    
    var userHasSwipedSentences = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white

        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.view?.addGestureRecognizer(self.panGestureRecognizer!)
        
        startX = (size.width / 2)
        startY = size.height
        
        self.shouldEnableEffects = true
        
        
        // init physics world
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsWorld.contactDelegate = self
        
        // Setup shaders
        self.shaderMove = SKShader(fileNamed: "shader_water.fsh")
//        self.shaderTwirl = SKShader(fileNamed: "swirl.fsh")
//        self.shader = self.shaderTwirl!
        
        // run actions
        self.waitAction = SKAction.wait(forDuration: 0.5)
        addSentences()
        
    }
    
    func addSentences() {
        // create sprite
        let topSentence = Sentence(type: SentenceType.fromTop, sentenceNumber: self.sentenceNumber)
        let bottomSentence = Sentence(type: SentenceType.fromBottom, sentenceNumber: self.sentenceNumber)
        
        if self.sentenceHeight == nil {
            self.sentenceHeight = topSentence.size.height
            self.waitAction?.duration = Double(self.sentenceHeight! / self.currentGameVelocity)
        }
        
        // set position of sprite just above and just below scene
        let sentenceOffset = topSentence.size.height / 2
        topSentence.position = CGPoint(x: startX, y: startY + sentenceOffset)
        bottomSentence.position = CGPoint(x: startX, y: bottomY - sentenceOffset)
        
        if self.nodeScale == nil {
            self.nodeScale = (size.width * 0.75) / topSentence.texture!.size().width
        }
        
        topSentence.setScale(self.nodeScale!)
        bottomSentence.setScale(self.nodeScale!)
        
        topSentence.setInitialVelocity(currentGameVelocity)
        bottomSentence.setInitialVelocity(currentGameVelocity)
        
        self.addChild(topSentence)
        self.addChild(bottomSentence)
        
        run(SKAction.sequence([
            self.waitAction!,
            SKAction.run(addSentences)
        ]))
    }
    
    // MARK: SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var topBody: SKPhysicsBody
        var bottomBody: SKPhysicsBody
        
        // figure out which sentence is on top
        if (contact.bodyA.node?.position.y > contact.bodyB.node?.position.y)  {
            topBody = contact.bodyA
            bottomBody = contact.bodyB
        } else {
            topBody = contact.bodyB
            bottomBody = contact.bodyA
        }
        
        sentencesDidCollide(topBody.node as! Sentence, bottomSentence: bottomBody.node as! Sentence)
    }
    
    func sentencesDidCollide(_ topSentence:Sentence, bottomSentence:Sentence) {
        if userHasSwipedSentences {
            let topVelocity = topSentence.physicsBody?.velocity
            let bottomVelocity = bottomSentence.physicsBody?.velocity
            
            topSentence.physicsBody?.applyForce(bottomVelocity!)
            bottomSentence.physicsBody?.applyForce(topVelocity!)
            
            // Cache the velocities for use after panning
            topSentence.currentVelocity = topSentence.physicsBody?.velocity
            bottomSentence.currentVelocity = bottomSentence.physicsBody?.velocity
            
            topSentence.run(SKAction.scale(by: currentScaleFactor, duration: 1.0))
            currentScaleFactor += 0.025
            
            animateGlobalFilter()
        } else {
            fadeAndRemoveSentences(topSentence, bottomSentence: bottomSentence)
        }
        
    }
    
    func animateGlobalFilter() {
        filterIsAnimating = true
        currentFilterValue += 80
    }
    
    func fadeAndRemoveSentences(_ topSentence:Sentence, bottomSentence:Sentence) {
        // Pretend like the collision didn't happen
        topSentence.physicsBody?.categoryBitMask = PhysicsCategory.SelectedSentence
        topSentence.physicsBody?.collisionBitMask = PhysicsCategory.SelectedSentence
        topSentence.physicsBody?.contactTestBitMask = PhysicsCategory.SelectedSentence
        topSentence.setInitialVelocity(10.0)
        bottomSentence.setInitialVelocity(10.0)
        
        // Run the animation
        let fadeAndShrink = SKAction.group([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.scale(by: 0.95, duration: 0.75)
            ])
        
        let fadeOutAndRemove = SKAction.sequence([
            fadeAndShrink,
            SKAction.removeFromParent()
            ])
        topSentence.run(fadeOutAndRemove)
        bottomSentence.run(fadeOutAndRemove)
    }
    
    
    // MARK: Actions
    
    func handlePanGesture (_ recognizer: UIPanGestureRecognizer) {
        
        // Convert the gesture touch point into a scene touch point
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        
        if recognizer.state == .began {
            
            // Get the touched node
            let touchedNode = self.atPoint(touchLocation)
            
            // Set up the selectedNode if sentence is touched
            if touchedNode is Sentence {
                self.userHasSwipedSentences = true
                self.selectedNode = touchedNode as? Sentence
                selectedNode?.physicsBody?.categoryBitMask = PhysicsCategory.SelectedSentence
                selectedNode?.physicsBody?.collisionBitMask = PhysicsCategory.SelectedSentence
                selectedNode?.physicsBody?.contactTestBitMask = PhysicsCategory.SelectedSentence
                selectedNode?.zPosition = 10.0
                selectedNode?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                
                selectedNode?.shader = self.shaderMove
                
                self.positionWhenTouched = selectedNode!.position
            }
            
        } else if recognizer.state == .changed {
            
            if let node = self.selectedNode {
                let translation = recognizer.translation(in: recognizer.view)
                node.position = CGPoint(x: positionWhenTouched!.x + translation.x, y: positionWhenTouched!.y - translation.y)
                
            }
            
        } else if recognizer.state == .ended {
            
            if let node = self.selectedNode {
                let v = recognizer.velocity(in: recognizer.view)
                
                if v.x > SWIPE_THRESHOLD || v.x < -SWIPE_THRESHOLD {
                    node.physicsBody?.velocity = CGVector(dx: v.x, dy: -v.y)
                    node.name = NODE_BEING_DISMISSED
                    increaseGameSpeed()
                } else {
                    // Move it back to center
                    let moveToCenter = SKAction.moveTo(x: self.size.width / 2, duration: 0.5)
                    moveToCenter.timingMode = SKActionTimingMode.easeOut
                    node.run(moveToCenter)
                    
                    node.physicsBody?.velocity = node.currentVelocity!
                    
                    // Re-enable collisions
                    node.physicsBody?.categoryBitMask = PhysicsCategory.Sentence
                    node.physicsBody?.collisionBitMask = PhysicsCategory.Sentence
                    node.physicsBody?.contactTestBitMask = PhysicsCategory.Sentence
                    node.zPosition = 0.0
                }
                
                node.shader = nil
                
                selectedNode = nil
            }
            
        }
    }
    
    func increaseGameSpeed() {
        let dy:CGFloat = 10.0
        self.currentGameVelocity += dy
        for child in self.children {
            if child is Sentence && child.name != NODE_BEING_DISMISSED {
                let sentence = child as! Sentence
                sentence.increaseVelocity(dy)
            }
        }
        
        self.waitAction?.duration = Double(self.sentenceHeight! / self.currentGameVelocity)
    }
   
    override func update(_ currentTime: TimeInterval) {
        // TODO replace 18000 with CONST
        if currentFilterValue > 18000 {
            // stop gameplay and transition to educational series
            moveToEducationSeries()
        }   
    }
    
    func moveToEducationSeries() {
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
        self.view?.presentScene(nil)
        self.parentViewController?.dismiss(animated: true, completion: nil)
        
    }
    
}

struct PhysicsCategory {
    static let None             : UInt32 = 0
    static let All              : UInt32 = UInt32.max
    static let Sentence         : UInt32 = 0b1       // 1
    static let SelectedSentence : UInt32 = 0b10      // 2
}
