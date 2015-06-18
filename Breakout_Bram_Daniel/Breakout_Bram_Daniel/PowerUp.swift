//
//  PowerUp.swift
//  Breakout_Bram_Daniel
//
//  Created by Student on 18-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import SpriteKit
class PowerUp: SKSpriteNode{
    init(imageName: String){
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}