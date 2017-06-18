//
//  Sentence.swift
//  OCD
//
//  Created by Andy Mockler on 6/18/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import SpriteKit
import GLKit

enum SentenceType {
    case fromTop, fromBottom
}

class Sentence: SKSpriteNode {
    let type: SentenceType?

    var velocity: CGFloat = 0.0 {
        didSet {
            physicsBody?.velocity = type == .fromTop
                ? CGVector(dx: 0.0, dy: -velocity)
                : CGVector(dx: 0.0, dy: velocity)
        }
    }

    init(type: SentenceType, sentenceNumber: Int) {
        self.type = type
        let assetImageName = "sentence-\(sentenceNumber)"
        let texture = SKTexture(imageNamed: assetImageName)

        super.init(texture: texture, color: UIColor.white, size: texture.size())
        color = UIColor.clear

        // Init Physics TODO: Can any of these properties be removed?
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.friction = 0.0
        physicsBody?.categoryBitMask = PhysicsCategories.Sentence
        physicsBody?.contactTestBitMask = PhysicsCategories.Sentence
        physicsBody?.collisionBitMask = PhysicsCategories.Sentence
        physicsBody?.mass = 5.0
        physicsBody?.allowsRotation = false
        physicsBody?.linearDamping = 0.0
        physicsBody?.angularDamping = 0.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
