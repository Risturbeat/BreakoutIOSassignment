//
//  Brick.swift
//  Breakout_Bram_Daniel
//
//  Created by Student on 18-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import SpriteKit
class Brick: SKSpriteNode{
    
    var numberOfHitsNeeded: Int = 0
    
    struct BrickNames {
        var brickOne = "brickOne"
        var brickTwo = "brickTwo"
        var brickThree = "brickThree"
    }
    let brickName = BrickNames()
    
    init(xOffset: CGFloat, yOffset: CGFloat){
        var imageName: String
        let randomNumber = arc4random_uniform(100)
        switch(randomNumber) {
        case 0...60:
            numberOfHitsNeeded = 1
            imageName = brickName.brickOne
            break
        case 60...90:
            numberOfHitsNeeded = 2
            imageName = brickName.brickTwo
            break
        case 90...100:
            numberOfHitsNeeded = 3
            imageName = brickName.brickThree
            break
        default:
            numberOfHitsNeeded = 1
            imageName = brickName.brickThree
        }

        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        position = CGPointMake(xOffset, yOffset)
        physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
        physicsBody!.allowsRotation = false
        physicsBody!.friction = 0.0
        physicsBody!.affectedByGravity = false
        physicsBody!.dynamic = false
        name = BrickCategoryName
        physicsBody!.categoryBitMask = BrickCategory
            }
    override init(texture:SKTexture, color: UIColor, size: CGSize){
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gotHit(){
        numberOfHitsNeeded--
        var imageName: String
        switch(numberOfHitsNeeded) {
        case 2:
            imageName = brickName.brickTwo
            break
        case 1:
            imageName = brickName.brickOne
            break
        default:
            imageName = "error"
            break
        }
        if imageName != "error" {
            texture = SKTexture(imageNamed: imageName)
        }
    }
}