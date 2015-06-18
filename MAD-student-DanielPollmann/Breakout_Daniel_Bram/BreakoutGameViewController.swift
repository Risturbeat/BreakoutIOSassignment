//
//  FirstViewController.swift
//  Breakout_Daniel_Bram
//
//  Created by Student on 05-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit
@IBDesignable
class BreakoutGameViewController: UIViewController, UICollisionBehaviorDelegate{
    
    @IBOutlet weak var gameView: UIView!
    var brickAmount: Int = 9
    var bricksLeft: Int = 0
    let brickDiameter: Int = 30
    let paddleHeight: Int = 30
    let paddleWidth: Int = 120
    var paddle: UIView! {
        didSet{
            paddle.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: "movePaddle:"))
        }
    }
    
    //    var ball: Ball = Ball(frame:CGRect(x:0,y:0,width:0,height:0))
    //    var paddle: UIView!
    var items: [UIView] = []
    var balls: [UIView] = []
    var blocks: [UIView] = []
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var bounceFactor : UIDynamicItemBehavior!
    var pushBehaviour: UIPushBehavior!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action: "pushBall:"))
        
        animator = UIDynamicAnimator(referenceView: view)

        bricksLeft = self.brickAmount
        addPaddle()
        addBricks()
        addBall()
        addWalls()
        addAnimation()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
    }
    func addAnimation(){
        pushBehaviour = UIPushBehavior(items: balls, mode: UIPushBehaviorMode.Instantaneous)
        pushBehaviour.magnitude = 0.1
        pushBehaviour.angle = 90
        animator.addBehavior(pushBehaviour)
        
        
        bounceFactor = UIDynamicItemBehavior(items: balls)
        bounceFactor.elasticity = 1.1
        animator.addBehavior(bounceFactor)
        
        var brickBehaviour = UIDynamicItemBehavior(items: blocks)
        brickBehaviour.resistance = CGFloat.max
        brickBehaviour.allowsRotation = false
        brickBehaviour.density = 0
        brickBehaviour.elasticity = 1
        animator.addBehavior(brickBehaviour)
        
        collision = UICollisionBehavior(items: items)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        
        collision.addBoundaryWithIdentifier("paddle", forPath: UIBezierPath(ovalInRect: paddle.frame))
        collision.addBoundaryWithIdentifier("leftWall", forPath: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2, height: self.view.frame.height)))
        collision.addBoundaryWithIdentifier("rightWall", forPath: UIBezierPath(rect: CGRect(x: self.view.frame.width-5, y:0 ,width: 2, height: self.view.frame.height)))
        collision.addBoundaryWithIdentifier("ceiling", forPath: UIBezierPath(rect: CGRect(x:0, y:0, width:500, height: 2)))
        collision.collisionMode = UICollisionBehaviorMode.Everything
        
        
        animator.addBehavior(collision)

    }
    
    func addBricks(){
        var maxBricksPerRow = Int(self.view.frame.width) / (brickDiameter+10)
        //Cannot put equal bricks on each row
        
        var brickXPosition = 20
        var brickYPosition = 70
        let spaceBetweenBricks = 5
        let maxRows = brickAmount / maxBricksPerRow
        var currentRow = 0
        
        for var i = 0; i < brickAmount; i++ {
            if i % maxBricksPerRow == 0 && i != 0{
                brickYPosition += brickDiameter + spaceBetweenBricks*2
                brickXPosition = 0
            }
            
            var brick = Brick(frame: CGRect(x: brickXPosition, y: brickYPosition, width: brickDiameter, height: brickDiameter))
            gameView.addSubview(brick)
            brick.setNeedsDisplay()
            blocks.append(brick)
            items.append(brick)
            brickXPosition = brickXPosition + brickDiameter + spaceBetweenBricks
        }
    }
    
    func addPaddle(){
        let paddleY = Int(gameView.frame.height) - Int(tabBarController!.tabBar.frame.height) - paddleHeight
        let paddleX = Int(gameView.frame.width/2) - paddleWidth/2
        paddle = UIView(frame: CGRect(x: paddleX, y: paddleY, width: 130, height: paddleHeight))
        paddle.backgroundColor = UIColor.redColor()
        gameView.addSubview(paddle)

    }
    
    func addBall(){
        let ballX = Int(paddle.center.x)
        let ballY = 0
        let ball = Ball(frame: CGRect(x:ballX, y: ballY, width : 20, height: 20))
        gameView.addSubview(ball)
        balls.append(ball)
        items.append(ball)
    }
    
    func addWalls(){
//        collision.addBoundaryWithIdentifier("leftWall", forPath: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 5, height: self.view.frame.height)))
//        collision.addBoundaryWithIdentifier("rightWall", forPath: UIBezierPath(rect: CGRect(x: self.view.frame.width-5, y:0 ,width: 5, height: self.view.frame.height)))
//        collision.addBoundaryWithIdentifier("ceiling", forPath: UIBezierPath(rect: CGRect(x:0, y:0, width:500, height: 5)))
        
    }
   
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem){
        if let brick  = item2 as? Brick{
            bricksLeft--
            if bricksLeft == 0 {
                gameWon()
            }
            self.collision.removeItem(brick)
            UIView.animateWithDuration(1.0, animations: {
                brick.transform = CGAffineTransformRotate(brick.transform, 3.1415926) //Source: http://stackoverflow.com/questions/24295669/rotate-a-uiview-infinitely-until-a-stop-method-is-called-and-animate-the-view-ba
                brick.alpha = 0.0
            
                }, completion:{ finished in
                    brick.removeFromSuperview()
                    
            })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func movePaddle(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Ended:
            fallthrough
        case .Changed:
            let translation = sender.translationInView(self.view)
            if let view = sender.view{
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
            }
            collision.removeBoundaryWithIdentifier("paddle")
            collision.addBoundaryWithIdentifier("paddle", forPath: UIBezierPath(ovalInRect: paddle.frame))
            sender.setTranslation(CGPointZero, inView: self.view)
        default:
            break
        }
    }
    
    func pushBall(sender: UITapGestureRecognizer){
        var pushBehaviour = UIPushBehavior(items: balls, mode: UIPushBehaviorMode.Instantaneous)
        pushBehaviour.magnitude = 0.2
        pushBehaviour.angle = CGFloat(Int(arc4random_uniform(360)+1))
        animator.addBehavior(pushBehaviour)
    }
    
    func gameWon(){
        showAlert("Congratulations", message: "You won the game")
//        animator.removeAllBehaviors()
        addBricks()
        addAnimation()
    }
    
    func resetGame(){
        balls = []
        blocks = []
        items = []
    }
    
    func showAlert(title: String, message:String){
        var alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertActionStyle.Default, handler: {alert in resetGame()}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}