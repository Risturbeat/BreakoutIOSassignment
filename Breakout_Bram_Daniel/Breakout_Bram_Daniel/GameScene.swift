
//
//  GameScene.swift
//  breakoutTest
//
//  Created by Student on 16-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BrickCategoryName = "brick"
let BrickNodeCategoryName = "blockNode"

let BallCategory   : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
let BottomCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let BrickCategory  : UInt32 = 0x1 << 2 // 00000000000000000000000000000100
let PaddleCategory : UInt32 = 0x1 << 3 // 00000000000000000000000000001000

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let defaults = NSUserDefaults.standardUserDefaults()
    var isFingerOnPaddle = false
    var brickAmount = 25
    var paddleScale = 1.0
    var livesLeft = 3//Default Life Amount
    var ballSpeed: Int = 10
    var ball: SKSpriteNode = SKSpriteNode()
    var lifeLabel : SKLabelNode = SKLabelNode()
    struct Settings {
        var ballSpeed = 10
        var paddleScale = 1.0
        var brickAmount = 25
        var liveAmount = 3
        
    }
    var settings = Settings()

    
    // MARK: - Set-Up
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        getVariablesFromUserDefaults()

        // 1. Create a physics body that borders the screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2. Set the friction of that physicsBody to 0
        borderBody.friction = 0
        // 3. Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 10)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        paddle.xScale = CGFloat(paddleScale)
//        etScale(CGFloat(paddleScale), CGFloat(1.0))
        createBall()
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
        
        lifeLabel = childNodeWithName("livesLabel") as! SKLabelNode
        lifeLabel.text = "\(settings.liveAmount)"
        
        createBricks()
    }
    
    func createBall(){
        ball = Ball(imageNamed: "ball")
        addChild(ball)
    }
    
    func createBricks(){
        
        
        // 1. Store some useful constants
        let brickWidth = SKSpriteNode(imageNamed: "brickOne").size.width
        let brickHeight = SKSpriteNode(imageNamed: "brickOne").size.height
        let totalBricksWidth = brickWidth * CGFloat(settings.brickAmount)
        
        let padding: CGFloat = 10.0
        let totalPadding = padding * CGFloat(settings.brickAmount - 1)
        


        // 2. Calculate the xOffset
        var xOffset = CGFloat(25)
        var yOffset = CGRectGetHeight(frame) * 0.9
        let maxBricksPerRow = Int(CGRectGetWidth(frame)-xOffset) / Int(brickWidth+padding)
        println("maxbricks   \(maxBricksPerRow)")
        // 3. Create the blocks and add them to the scene
        for i in 0 ..< settings.brickAmount {
            if i % maxBricksPerRow == 0 && i != 0{
                yOffset = yOffset - brickHeight - padding
                xOffset = CGFloat(25)
            }
            xOffset = xOffset + brickWidth + padding
            //TODO: create new brick class
//            let brick = SKSpriteNode(imageNamed: "brickOne")
//            brick.position = CGPointMake(xOffset, yOffset)
//            brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
//            brick.physicsBody!.allowsRotation = false
//            brick.physicsBody!.friction = 0.0
//            brick.physicsBody!.affectedByGravity = false
//            brick.physicsBody!.dynamic = false
//            brick.name = BrickCategoryName
//            brick.physicsBody!.categoryBitMask = BrickCategory
            let brick = Brick(xOffset: xOffset, yOffset: yOffset)
            addChild(brick)
        }
    }
    
    func getVariablesFromUserDefaults(){
        
        //TODO: check if nil
        settings.brickAmount = defaults.objectForKey("brickAmount") as! Int
        settings.liveAmount = defaults.objectForKey("lifeAmount") as! Int
        settings.paddleScale = defaults.objectForKey("paddleScale") as! Double
        if let speed = defaults.objectForKey("speed") as? Bool {
            println(speed)
            switch(speed) {
            case true:
                settings.ballSpeed = 50
                break
            case false:
                settings.ballSpeed = 10
                break
            default:
                break
            }
        }
        
        //        ballAmount = defaults.objectForKey(")
    }
    
    //MARK: - Collision Detection
    
    func didBeginContact(contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 3. react to the contact between ball and bottom
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            ball.removeFromParent()
                settings.liveAmount--
                lifeLabel.text = "\(settings.liveAmount)"
                println("ground hit")
                if settings.liveAmount == 0 {
                    if let mainView = view {
                        let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as! GameOverScene
                        gameOverScene.gameWon = false
                        mainView.presentScene(gameOverScene)
                    }
                }
            createBall()
        }
        
        //4. Ball/Block contact
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BrickCategory {
            var brickBody = secondBody.node as? Brick
            brickBody!.gotHit()
            if brickBody?.numberOfHitsNeeded == 0 {
                secondBody.categoryBitMask = 0x1 >> 3 //Change BitMask so the block is not collidable
                secondBody.node!.runAction(SKAction.rotateByAngle(6.2831853072, duration: 1))
                secondBody.node!.runAction(SKAction.fadeOutWithDuration(2), completion : {
                    secondBody.node!.removeFromParent()
                    if self.isGameWon() {
                        if let mainView = self.view {
                            let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as! GameOverScene
                            gameOverScene.gameWon = true
                            mainView.presentScene(gameOverScene)
                        }
                    }
                } )
            }
        }
    }
    
    func isGameWon() -> Bool {
        var numberOfBricks = 0
        self.enumerateChildNodesWithName(BrickCategoryName) {
            node, stop in
            numberOfBricks = numberOfBricks + 1
        }
        return numberOfBricks == 0
    }
    
    // MARK: - Paddle Movement
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches.first as! UITouch
        var touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == PaddleCategoryName {
                isFingerOnPaddle = true
            }
        }else{
            var angle = CGFloat(arc4random_uniform(360) + 1)
            var speed = CGFloat(arc4random_uniform(UInt32(settings.ballSpeed)) + 20)
            //If no body is present, push the ball
            ball.physicsBody!.applyImpulse(CGVectorMake(cos(angle) * speed, sin(angle) * speed))
        }
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if isFingerOnPaddle {
            // 2. Get touch location
            var touch = touches.first as! UITouch
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            var paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
            
            // 4. Calculate new x position
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            // 5. Paddle may not move off the screen
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            // 6. Update paddle position
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        isFingerOnPaddle = false
    }
}