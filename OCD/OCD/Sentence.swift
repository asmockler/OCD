//
//  Sentence.swift
//  OCD
//
//  Created by Dan Morain on 4/14/16.
//  Copyright © 2016 Andy Mockler. All rights reserved.
//

import SpriteKit

enum SentenceType {
    case FromTop, FromBottom
}


class Sentence: SKSpriteNode {
    
    init(type: SentenceType) {
        let texture = SKTexture(imageNamed: "sentence")
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        
        initPhysics(type)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(type: SentenceType) {
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
        
        if type == .FromTop {
            self.physicsBody?.velocity = CGVectorMake(0.0, -100.0)
        } else if type == .FromBottom {
            self.physicsBody?.velocity = CGVectorMake(0.0, 100.0)
        }
    }
    
}
