//
//  PowerUp.swift
//  Breakout_Bram_Daniel
//
//  Created by Student on 18-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import SpriteKit
class PowerUp: SKSpriteNode{
    var powerUpName: String = ""
    
    init(imageName: String, xPos: CGFloat, yPos: CGFloat){
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        powerUpName = imageName
        position = CGPointMake(xPos, yPos)
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.allowsRotation = false
        physicsBody!.friction = 0
        physicsBody!.restitution = 1
        physicsBody!.linearDamping = 0
        physicsBody!.angularDamping = 0
        physicsBody!.categoryBitMask = PowerUpCategory
        physicsBody!.contactTestBitMask = PaddleCategory | BottomCategory
        physicsBody?.collisionBitMask = BottomCategory
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}