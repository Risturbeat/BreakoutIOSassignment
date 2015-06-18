//
//  GameOverScene.swift
//  Breakout_Bram_Daniel
//
//  Created by Student on 17-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import SpriteKit

let GameOverLabelCategoryName = "gameOverLabel"

class GameOverScene: SKScene {
    var gameWon : Bool = false {
        // 1.
        didSet {
            let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as! SKLabelNode
            gameOverLabel.text = gameWon ? "Game Won" : "Game Over"
        }
    }
    
    var points : Int = 0 {
        didSet {
            let pointLabel = childNodeWithName("pointLabel") as! SKLabelNode
            pointLabel.text = "\(points)"
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let view = view {
            // 2.
            let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene
            view.presentScene(gameScene)
        }
    }
}
