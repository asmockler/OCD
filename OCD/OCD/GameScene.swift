//
//  GameScene.swift
//  OCD
//
//  Created by Andy on 4/14/16.
//  Copyright (c) 2016 Andy Mockler. All rights reserved.
//


// TODO
// NOW
// Collision distortions
// Improve shader select animation
// Clean things up
//
// LATER
// Look into using timingFunction for the wait action timing



import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Properties
    let SWIPE_THRESHOLD:CGFloat = 1500
    let NODE_BEING_DISMISSED = "node being dismissed"
    var currentGameVelocity:CGFloat = 10.0
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
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()

        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.view?.addGestureRecognizer(self.panGestureRecognizer!)
        
        startX = size.width/2
        startY = size.height
        
        self.shouldEnableEffects = true
        
        // init physics world
        physicsWorld.gravity = CGVectorMake(0,0)
        physicsWorld.contactDelegate = self
        
        
        // run actions
        self.waitAction = SKAction.waitForDuration(3.0)
        addSentences()

        self.shaderMove = SKShader(fileNamed: "shader_water.fsh")
    
    }
    
    func addSentences() {
        // create sprite
        let topSentence = Sentence(type: SentenceType.FromTop)
        let bottomSentence = Sentence(type: SentenceType.FromBottom)
        
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
        
        runAction(SKAction.sequence([
            self.waitAction!,
            SKAction.runBlock(addSentences)
            ]))
    }
    
    // MARK: SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        
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
    
    func sentencesDidCollide(topSentence:Sentence, bottomSentence:Sentence) {
        
        let topVelocity = topSentence.physicsBody?.velocity
        let bottomVelocity = bottomSentence.physicsBody?.velocity
        
        topSentence.physicsBody?.applyForce(bottomVelocity!)
        bottomSentence.physicsBody?.applyForce(topVelocity!)
        
        // Cache the velocities for use after panning
        topSentence.currentVelocity = topSentence.physicsBody?.velocity
        bottomSentence.currentVelocity = bottomSentence.physicsBody?.velocity
    }
    
    
    
    // MARK: Actions
    
    func handlePanGesture (recognizer: UIPanGestureRecognizer) {
        
        // Convert the gesture touch point into a scene touch point
        var touchLocation = recognizer.locationInView(recognizer.view)
        touchLocation = self.convertPointFromView(touchLocation)
        
        if recognizer.state == .Began {
            
            // Get the touched node
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            // Set up the selectedNode if sentence is touched
            if touchedNode is Sentence {
                self.selectedNode = touchedNode as? Sentence
                selectedNode?.physicsBody?.categoryBitMask = PhysicsCategory.SelectedSentence
                selectedNode?.physicsBody?.collisionBitMask = PhysicsCategory.SelectedSentence
                selectedNode?.physicsBody?.contactTestBitMask = PhysicsCategory.SelectedSentence
                selectedNode?.zPosition = 10.0
                selectedNode?.physicsBody?.velocity = CGVectorMake(0, 0)
                
                selectedNode?.shader = self.shaderMove
                
                self.positionWhenTouched = selectedNode!.position
            }
            
        } else if recognizer.state == .Changed {
            
            if let node = self.selectedNode {
                let translation = recognizer.translationInView(recognizer.view)
                node.position = CGPointMake(positionWhenTouched!.x + translation.x, positionWhenTouched!.y - translation.y)
                
            }
            
        } else if recognizer.state == .Ended {
            
            if let node = self.selectedNode {
                let v = recognizer.velocityInView(recognizer.view)
                
                if v.x > SWIPE_THRESHOLD || v.x < -SWIPE_THRESHOLD {
                    node.physicsBody?.velocity = CGVectorMake(v.x, -v.y)
                    node.name = NODE_BEING_DISMISSED
                    increaseGameSpeed()
                } else {
                    // Move it back to center
                    let moveToCenter = SKAction.moveToX(self.size.width / 2, duration: 0.5)
                    moveToCenter.timingMode = SKActionTimingMode.EaseOut
                    node.runAction(moveToCenter)
                    
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
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    
    
    
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Sentence   : UInt32 = 0b1       // 1
    static let SelectedSentence: UInt32 = 0b10      // 2
}
