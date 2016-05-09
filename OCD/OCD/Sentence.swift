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
    case FromTop, FromBottom
}


class Sentence: SKSpriteNode {
    
    var type:SentenceType?
    var currentVelocity:CGVector?
    var effect:GLKBaseEffect?
    
    init(type: SentenceType) {
        
        let texture = SKTexture(imageNamed: "sentence")
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        
    
        self.type = type
        self.effect = GLKBaseEffect()
//        effect?.transform.
        let projectionMatrix = GLKMatrix4MakeOrtho(0, Float(texture.size().width), 0, Float(texture.size().height), -1, 1)
        self.effect!.transform.projectionMatrix = projectionMatrix
        self.texture?.textureByApplyingCIFilter(CIFilter(name: "CIBumpDistortion")!)
        
        initPhysics()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics() {
        // init physics body
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.friction = 0.0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Sentence
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Sentence
        self.physicsBody?.collisionBitMask = PhysicsCategory.Sentence
        self.physicsBody?.mass = 5.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
    }
    
    func setInitialVelocity(dy:CGFloat) {
        if self.type == .FromTop {
            self.physicsBody?.velocity = CGVectorMake(0.0, -dy)
        } else if type == .FromBottom {
            self.physicsBody?.velocity = CGVectorMake(0.0, dy)
        }
        
        self.currentVelocity = self.physicsBody?.velocity
    }
    
    func increaseVelocity(dy:CGFloat) {
        if self.type == .FromTop {
            self.physicsBody?.velocity.dy -= dy
        } else if type == .FromBottom {
            self.physicsBody?.velocity.dy += dy
        }
        
        self.currentVelocity = self.physicsBody?.velocity
    }
    
}
