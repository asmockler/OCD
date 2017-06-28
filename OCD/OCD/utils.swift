//
//  utils.swift
//  OCD
//
//  Created by Andy Mockler on 6/28/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import SpriteKit
import GLKit

struct OCD {
    static func random(min: Float, max: Float) -> Float {
        let randomDecimal = Float(arc4random()) / Float(UInt32.max)
        return (randomDecimal * (max - min)) + min
    }

    static func generateWarpGeometry(gridSize: Int, transform: (_ value: Float) -> Float) -> [vector_float2] {
        let stepSize = 1 / Float(gridSize)

        var result: [vector_float2] = []
        for rowIndex in 0...gridSize {
            for columnIndex in 0...gridSize {
                result.append(vector_float2(
                    transform(Float(columnIndex) * stepSize),
                    transform(Float(gridSize - rowIndex) * stepSize)
                ))
            }
        }

        return result
    }

    static func generateWarpGeometry(gridSize: Int) -> [vector_float2] {
        return generateWarpGeometry(gridSize: gridSize, transform: {(value) in return value})
    }
}
