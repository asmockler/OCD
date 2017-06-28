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

let TRANSFORM_TOLERANCE: Float = 0.005
let WARP_GRID_SIZE: Int = 10

class Sentence: SKSpriteNode {
    let type: SentenceType?
    var velocity: CGFloat = 0.0 {
        didSet {
            physicsBody?.velocity = type == .fromTop
                ? CGVector(dx: 0.0, dy: -velocity)
                : CGVector(dx: 0.0, dy: velocity)
        }
    }

    // MARK: Properties - warp geometry
    var currentWarpGeometry: [vector_float2] = OCD.generateWarpGeometry(gridSize: WARP_GRID_SIZE)
    var isCurrentlyWarping = false

    // MARK: Initialization

    init(type: SentenceType, sentenceNumber: Int) {
        self.type = type
        let assetImageName = "sentence-\(sentenceNumber)"
        let texture = SKTexture(imageNamed: assetImageName)

        super.init(texture: texture, color: UIColor.white, size: texture.size())
        color = UIColor.clear

        // Init warp geometry
        if #available(iOS 10.0, *) {
            warpGeometry = SKWarpGeometryGrid(
                columns: WARP_GRID_SIZE,
                rows: WARP_GRID_SIZE,
                sourcePositions: currentWarpGeometry,
                destinationPositions: currentWarpGeometry
            )
        }

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

    // MARK: Effects methods
    @available(iOS 10.0, *)
    func animateWarpEffect() {
        if isCurrentlyWarping {
            return
        }

        isCurrentlyWarping = true

        let destinationPositions = OCD.generateWarpGeometry(gridSize: WARP_GRID_SIZE, transform: randTransform(_:))

        let newWarpGeometryGrid = SKWarpGeometryGrid(
            columns: WARP_GRID_SIZE,
            rows: WARP_GRID_SIZE,
            sourcePositions: currentWarpGeometry,
            destinationPositions: destinationPositions
        )

        // Create the warp action
        let warpDuration = TimeInterval(OCD.random(min: 1.0, max: 2.0))
        let warpAction = SKAction.warp(to: newWarpGeometryGrid, duration: warpDuration)

        // This sucks, but as of iOS 10, completion handlers don't seem to work for
        // warp actions. So we run the warp action and a separate wait action
        // to handle the callback.
        run(warpAction!)
        run(SKAction.wait(forDuration: warpDuration)) {
            self.currentWarpGeometry = destinationPositions
            self.isCurrentlyWarping = false
            self.animateWarpEffect()
        }
    }

    private func randTransform(_ value: Float) -> Float {
        return OCD.random(min: value - TRANSFORM_TOLERANCE, max: value + TRANSFORM_TOLERANCE)
    }
}
