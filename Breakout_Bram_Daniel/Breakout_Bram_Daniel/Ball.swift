//
//  Ball.swift
//  Breakout_Bram_Daniel
//
//  Created by Student on 17-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import SpriteKit
class Ball: SKSpriteNode{
    
    init(imageNamed: String, xPos: CGFloat){
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        position = CGPointMake(xPos,70)
        physicsBody = SKPhysicsBody(circleOfRadius: 15)
        physicsBody!.allowsRotation = false
        physicsBody!.friction = 0
        physicsBody!.restitution = 1
        physicsBody!.linearDamping = 0
        physicsBody!.angularDamping = 0
        
        physicsBody!.categoryBitMask = BallCategory
        physicsBody!.contactTestBitMask = BottomCategory | BrickCategory
    }
    
    override init(texture:SKTexture, color: UIColor, size: CGSize){
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}