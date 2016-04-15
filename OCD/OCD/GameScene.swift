//
//  GameScene.swift
//  OCD
//
//  Created by Andy on 4/14/16.
//  Copyright (c) 2016 Andy Mockler. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Properties
    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0
    var bottomY: CGFloat = 0.0
    
    var selectedNode: Sentence?
    
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        startX = size.width/2
        startY = size.height
        
        // init physics world
        physicsWorld.gravity = CGVectorMake(0,0)
        physicsWorld.contactDelegate = self
        
        // run actions
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addSentence),
                SKAction.waitForDuration(1.0)
                ])
            ))
    }
    
    func addSentence() {
        // create sprite
        let topSentence = Sentence(type: SentenceType.FromTop)
        let bottomSentence = Sentence(type: SentenceType.FromBottom)
        
        // set position of sprite on scene
        topSentence.position = CGPoint(x: startX, y: startY)
        bottomSentence.position = CGPoint(x: startX, y: bottomY)
        
        addChild(topSentence)
        addChild(bottomSentence)
        
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
        
    }
    
    
    
    // MARK: Actions
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        let positionInScene = touch?.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(positionInScene!)
        
        if touchedNode is Sentence {
            selectedNode = touchedNode as? Sentence
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let previousTouchPosition = touch?.previousLocationInNode(self)
        let currentTouchPosition = touch?.locationInNode(self)
        
        let diffX:CGFloat = currentTouchPosition!.x - previousTouchPosition!.x
        let diffY:CGFloat = currentTouchPosition!.y - previousTouchPosition!.y
        
        let previousPosition = selectedNode!.position
        selectedNode!.position = CGPoint(x: previousPosition.x + diffX, y: previousPosition.y + diffY)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        selectedNode = nil
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Sentence   : UInt32 = 0b1       // 1
    //    static let Projectile: UInt32 = 0b10      // 2
}
