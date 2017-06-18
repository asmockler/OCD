//
//  GameScene.swift
//  OCD
//
//  Created by Andy Mockler on 6/18/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import UIKit
import SpriteKit

// TODO
// Should move the PhysicsCategories struct to a constants file? (probs yah)
// Make sure everything that can be private is private
// Go through all other TODOs in the file

struct PhysicsCategories {
    static let None             : UInt32 = 0
    static let All              : UInt32 = UInt32.max
    static let Sentence         : UInt32 = 0b1  // 1
    static let SelectedSentence : UInt32 = 0b10 // 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: Constants

    private let SWIPE_THRESHOLD: CGFloat = 1500.0
    private let NODE_BEING_DISMISSED = "node being dismissed"


    // MARK: Properties

    var sentenceNumber: Int = (Int(arc4random_uniform(5)) + 1)
    var parentViewController: GameViewController?

    var panGestureRecognizer: UIPanGestureRecognizer?

    var sentenceHeight: CGFloat?
    var nodeScale: CGFloat?

    let shaderMove: SKShader? = SKShader(fileNamed: "./Shaders/water.fsh")


    // MARK: Properties - Game Dynamics

    var currentGameVelocity: CGFloat = 25.0
    var currentScaleFactor: CGFloat = 1.1
    let waitAction = SKAction.wait(forDuration: 0.5)
    var userHasSwipedSentences = false
    var filterIsAnimating = false
    var currentFilterValue = 1


    // MARK: Properties - Drag and drop
    var positionWhenTouched: CGPoint?
    var selectedNode: Sentence?


    // MARK: Animations
    let fadeAndRemoveAnimation = SKAction.sequence([
        SKAction.group([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.scale(by: 0.95, duration: 0.75)
        ]),
        SKAction.removeFromParent()
    ])
    var moveToCenter: SKAction?


    // MARK: SKScene

    // Called immediately after a scene is presented by a view
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        shouldEnableEffects = true
        view.allowsTransparency = true

        // Create gesture recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGestureRecognizer!)

        // Init physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self // TODO: you could move this out if things are too big

        // Init moveToCenter animation
        moveToCenter = SKAction.moveTo(x: size.width / 2, duration: 0.5)
        moveToCenter?.timingMode = SKActionTimingMode.easeOut

        // Run actions (TODO: Can these move to a different lifecycle method?)
        addSentences()
    }

    override func update(_ currentTime: TimeInterval) {
        // TODO replace 18000 with an approprite constant (or calculate it)
        if currentFilterValue > 18000 {
            removeAllActions()
            removeAllChildren()
            removeFromParent()
            view?.presentScene(nil)
            parentViewController?.dismiss(animated: true, completion: nil)
        }
    }


    // MARK: SKPhysicsContactDelegate

    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node == nil || contact.bodyB.node == nil) {
            return
        }

        var topBody: SKPhysicsBody
        var bottomBody: SKPhysicsBody

        // Figure out which one is on top
        if (contact.bodyA.node!.position.y > contact.bodyB.node!.position.y) {
            topBody = contact.bodyA
            bottomBody = contact.bodyB
        } else {
            topBody = contact.bodyB
            bottomBody = contact.bodyA
        }

        let topSentence = topBody.node as! Sentence
        let bottomSentence = bottomBody.node as! Sentence

        if userHasSwipedSentences {
            handleSentenceCollision(topSentence: topSentence, bottomSentence: bottomSentence)
        } else {
            fadeAndRemoveSentences(topSentence: topSentence, bottomSentence: bottomSentence)
        }
    }

    // MARK: Actions

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = convertPoint(fromView: recognizer.location(in: recognizer.view))

        switch recognizer.state {
        case .began:
            // When a touch begins, start tracking the selected node
            let touchedNode = atPoint(touchLocation)

            if touchedNode is Sentence {
                userHasSwipedSentences = true
                selectedNode = touchedNode as? Sentence
                setCollisionBehavior(body: (selectedNode?.physicsBody!)!, category: PhysicsCategories.SelectedSentence)
                selectedNode?.zPosition = 10.0
                selectedNode?.velocity = 0

                selectedNode?.shader = shaderMove

                positionWhenTouched = selectedNode!.position
            }
        case .changed:
            // As the gesture changes, move the node around
            if let node = selectedNode {
                let translation = recognizer.translation(in: recognizer.view)
                node.position = CGPoint(
                    x: positionWhenTouched!.x + translation.x,
                    y: positionWhenTouched!.y - translation.y
                )
            }
        case .ended:
            // When the swipe ends, either throw the node off the screen or return it to center
            if let node = selectedNode {
                let gestureVelocity = recognizer.velocity(in: recognizer.view)

                if abs(gestureVelocity.x) > SWIPE_THRESHOLD {
                    node.physicsBody?.velocity = CGVector(dx: gestureVelocity.x, dy: -gestureVelocity.y)
                    node.name = NODE_BEING_DISMISSED
                    increaseGameSpeed()
                } else {
                    node.run(moveToCenter!)
                    node.velocity = currentGameVelocity
                    setCollisionBehavior(body: node.physicsBody!, category: PhysicsCategories.Sentence)
                    node.zPosition = 0.0
                }

                node.shader = nil
                selectedNode = nil
            }
        default:
            return
        }
    }


    // MARK: Private functions

    private func addSentences() {
        let topSentence = Sentence(type: .fromTop, sentenceNumber: sentenceNumber)
        let bottomSentence = Sentence(type: .fromBottom, sentenceNumber: sentenceNumber)

        if sentenceHeight == nil {
            sentenceHeight = topSentence.size.height
            waitAction.duration = Double(sentenceHeight! / currentGameVelocity)
        }

        // Set position of sprite just above and just below scene
        let sentenceOffset = topSentence.size.height / 2 // TODO: This sentence size info can probs get factored out somewhere
        topSentence.position = CGPoint(x: size.width / 2, y: size.height + sentenceOffset)
        bottomSentence.position = CGPoint(x: size.width / 2, y: -sentenceOffset)

        // TODO: This can probably end up wherever the sentence offset stuff happens
        if nodeScale == nil {
            nodeScale = (size.width * 0.75) / topSentence.texture!.size().width
        }

        topSentence.setScale(nodeScale!)
        topSentence.velocity = currentGameVelocity
        bottomSentence.setScale(nodeScale!)
        bottomSentence.velocity = currentGameVelocity
        addChild(topSentence)
        addChild(bottomSentence)

        run(SKAction.sequence([
            waitAction,
            SKAction.run(addSentences)
        ]))
    }


    // MARK: Sentence collision behavior

    private func handleSentenceCollision(topSentence: Sentence, bottomSentence: Sentence) {
        let topVelocity = topSentence.physicsBody?.velocity
        let bottomVelocity = bottomSentence.physicsBody?.velocity

        topSentence.physicsBody?.applyForce(bottomVelocity!)
        bottomSentence.physicsBody?.applyForce(topVelocity!)

        //        // Cache the velocities for use after panning
        //        topSentence.currentVelocity = topSentence.physicsBody?.velocity
        //        bottomSentence.currentVelocity = bottomSentence.physicsBody?.velocity

        topSentence.run(SKAction.scale(by: currentScaleFactor, duration: 1.0))
        currentScaleFactor += 0.025

        filterIsAnimating = true
        currentFilterValue += 80
    }

    private func fadeAndRemoveSentences(topSentence: Sentence, bottomSentence: Sentence) {
        // Pretend like the collision didn't happen
        setCollisionBehavior(body: topSentence.physicsBody!, category: PhysicsCategories.SelectedSentence)
        setCollisionBehavior(body: bottomSentence.physicsBody!, category: PhysicsCategories.SelectedSentence)

        topSentence.run(fadeAndRemoveAnimation)
        bottomSentence.run(fadeAndRemoveAnimation)
    }

    private func increaseGameSpeed() {
        let dy: CGFloat = 10.0

        currentGameVelocity += dy
        for child in children {
            if child is Sentence && child.name != NODE_BEING_DISMISSED {
                let sentence = child as! Sentence
                sentence.velocity += dy
            }
        }
    }

    private func setCollisionBehavior(body: SKPhysicsBody, category: UInt32) {
        body.categoryBitMask = category
        body.collisionBitMask = category
        body.contactTestBitMask = category
    }

}
