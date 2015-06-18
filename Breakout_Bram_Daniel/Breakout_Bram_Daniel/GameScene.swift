
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
let PowerUpCategory : UInt32 = 0x1 << 4 //00000000000000000000000000010000

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let defaults = NSUserDefaults.standardUserDefaults()
    private var isFingerOnPaddle = false
    private var bricksLeftInGame: Int = 0
    private var ball = SKSpriteNode()
    private var paddle = SKSpriteNode()
    private var lifeLabel = SKLabelNode()
    private var ballFired = false
    private var pointsLabel = SKLabelNode()
    private var points: Int = 0
    private var timer: NSTimer = NSTimer()
    
    private struct Settings {
        var ballSpeed = 10
        var paddleScale = 1.0
        var brickAmount = 25
        var lifeAmount = 3
        var ballAmount = 2
    }
    private var settings = Settings()

    
    // MARK: - Set-Up
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        getVariablesFromUserDefaults()
        
        lifeLabel = childNodeWithName("livesLabel") as! SKLabelNode
        lifeLabel.text = "\(settings.lifeAmount)"
        pointsLabel = childNodeWithName("pointsLabel") as! SKLabelNode
        pointsLabel.text = "\(points)"
        
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
        
        paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode
        paddle.xScale = CGFloat(settings.paddleScale)

        createBall()
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
        createBricks()
    }
    
    func createBall(){
        ball = Ball(imageNamed: "ball", xPos: paddle.position.x)
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

        // 3. Create the blocks and add them to the scene
        for i in 0 ..< settings.brickAmount {
            if i % maxBricksPerRow == 0 && i != 0{
                yOffset = yOffset - brickHeight - padding
                xOffset = CGFloat(25)
            }
            xOffset = xOffset + brickWidth + padding
            let brick = Brick(xOffset: xOffset, yOffset: yOffset)
            addChild(brick)
        }
    }
    
    func getVariablesFromUserDefaults(){
        if let savedBrickAmount = defaults.objectForKey("brickAmount") as? Int {
                settings.brickAmount = savedBrickAmount
        }
        bricksLeftInGame = settings.brickAmount
        
        if let savedLifeAmount = defaults.objectForKey("lifeAmount") as? Int {
            settings.lifeAmount = savedLifeAmount
        }
        
        if let savedPaddleScale = defaults.objectForKey("paddleScale") as? Double{
            settings.paddleScale = savedPaddleScale
        }
        
        if let speed = defaults.objectForKey("speed") as? Bool {
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
        if let previousPoints = defaults.objectForKey("points") as? Int{
            points = previousPoints
        }
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
                settings.lifeAmount--
                ballFired = false
                lifeLabel.text = "\(settings.lifeAmount)"
                if settings.lifeAmount == 0 {
                    if let mainView = view {
                        resetPoints()
                        showGameOverScene(false)
                    }
                }
            createBall()
        }
        
        //4. Ball/Block contact
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BrickCategory {
            var brickBody = secondBody.node as? Brick
            points += brickBody!.gotHit()
            pointsLabel.text = "\(points)"
            if brickBody?.numberOfHitsNeeded == 0 {
                secondBody.categoryBitMask = 0x1 >> 3 //Change BitMask so the block is not collidable
                secondBody.node!.runAction(SKAction.rotateByAngle(6.2831853072, duration: 1))
                secondBody.node!.runAction(SKAction.fadeOutWithDuration(2), completion : {
                    secondBody.node!.removeFromParent()
                } )
                if (brickBody!.hasPowerUp) {
                    var powerUp = PowerUp(imageName: brickBody!.powerUpName, xPos: brickBody!.position.x, yPos: brickBody!.position.y)
                    addChild(powerUp)
                    powerUp.physicsBody!.applyImpulse(CGVectorMake(0, -5))
                }
                bricksLeftInGame--
                if self.isGameWon() {
                    firstBody.categoryBitMask = 0x1 >> 3
                    let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "gameOver:", userInfo: true, repeats: false)
                }
            }
        }
        //5. powerUp/paddle contact
        if firstBody.categoryBitMask == PaddleCategory && secondBody.categoryBitMask == PowerUpCategory {
            var powerUp = secondBody.node as? PowerUp
            secondBody.node!.removeFromParent()
            switch (powerUp!.powerUpName){
                case "powerUpPaddleIncrease":
                    paddle.xScale = CGFloat(2)
                    timer.invalidate()
                    timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "resetPaddleToOriginalSize:", userInfo: true, repeats: false)
                break
                
                case "powerUpExtraLife":
                    settings.lifeAmount++
                    lifeLabel.text = "\(settings.lifeAmount)"
                break
                
                default:
                break
            }
        }
        //6. powerUp/Bottom contact
        if firstBody.categoryBitMask == BottomCategory && secondBody.categoryBitMask == PowerUpCategory {
            secondBody.node?.removeFromParent()
        }
    }
    func resetPoints(){
        points = 0
        pointsLabel.text = "\(points)"
    }
    func resetPaddleToOriginalSize(timer: NSTimer){
        paddle.xScale = CGFloat(settings.paddleScale)
    }
    
    func gameOver(timer: NSTimer) {
        resetPoints()
        showGameOverScene(true)
    }
    func showGameOverScene(userWon: Bool){
        if let mainView = self.view {
            let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as! GameOverScene
            gameOverScene.gameWon = userWon
            mainView.presentScene(gameOverScene)
        }
    }
    
    func isGameWon() -> Bool {
        return bricksLeftInGame == 0
    }
    
    // MARK: - Paddle Movement
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches.first as! UITouch
        var touchLocation = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == PaddleCategoryName {
                isFingerOnPaddle = true
            }
        } else {
            var angle = CGFloat(arc4random_uniform(360) + 1)
            var speed = CGFloat(arc4random_uniform(UInt32(settings.ballSpeed)) + 20)
            ballFired = true
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
            
            if !ballFired {
                ball.position.x = paddle.position.x
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        isFingerOnPaddle = false
    }
    
    //MARK: - View removed from screen
    override func willMoveFromView(view: SKView) {
        defaults.setObject(points, forKey: "points")
    }
}