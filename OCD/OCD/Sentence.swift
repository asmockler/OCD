//
//  Sentence.swift
//  OCD
//
//  Created by Dan Morain on 4/14/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import SpriteKit
import GLKit

enum SentenceType {
    case fromTop, fromBottom
}


class Sentence: SKSpriteNode {
    
    var type:SentenceType?
    var currentVelocity:CGVector?
    var effect:GLKBaseEffect?
    var sentenceNumber:Int?
    
    init(type: SentenceType, sentenceNumber: Int) {
        
        let sentenceString = "sentences-" + String(sentenceNumber)
        
        let texture = SKTexture(imageNamed: sentenceString)
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        self.type = type
        self.sentenceNumber = sentenceNumber
        self.effect = GLKBaseEffect()
        let projectionMatrix = GLKMatrix4MakeOrtho(0, Float(texture.size().width), 0, Float(texture.size().height), -1, 1)
        self.effect!.transform.projectionMatrix = projectionMatrix
        self.texture?.applying(CIFilter(name: "CIBumpDistortion")!)
        
        initPhysics()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics() {
        // init physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.friction = 0.0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Sentence
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Sentence
        self.physicsBody?.collisionBitMask = PhysicsCategory.Sentence
        self.physicsBody?.mass = 5.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
    }
    
    func setInitialVelocity(_ dy:CGFloat) {
        if self.type == .fromTop {
            self.physicsBody?.velocity = CGVector(dx: 0.0, dy: -dy)
        } else if type == .fromBottom {
            self.physicsBody?.velocity = CGVector(dx: 0.0, dy: dy)
        }
        
        self.currentVelocity = self.physicsBody?.velocity
    }
    
    func increaseVelocity(_ dy:CGFloat) {
        if self.type == .fromTop {
            self.physicsBody?.velocity.dy -= dy
        } else if type == .fromBottom {
            self.physicsBody?.velocity.dy += dy
        }
        
        self.currentVelocity = self.physicsBody?.velocity
    }
    
}
