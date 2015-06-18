//
//  Paddle.swift
//  Breakout_Daniel_Bram
//
//  Created by Student on 05-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class Paddle: UIView{
    
    var paddleCenter : CGPoint = CGPoint(){
        didSet{
            setPaddleCenterToCenter = false
            setNeedsDisplay()
        }
    }
    var setPaddleCenterToCenter : Bool = true { didSet { if setPaddleCenterToCenter{ setNeedsDisplay() } } }
    
    
    override func drawRect(rect: CGRect) {
        if setPaddleCenterToCenter{
            paddleCenter = center
        }
        
//        self.backgroundColor = UIColor.redColor()
//        self.backgroundColor?.set()
    }
    
    func movePaddle(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Ended:
            fallthrough
        case .Changed:
            let translation = sender.translationInView(self)
            paddleCenter.x += translation.x
            paddleCenter.y += translation.y
           
            //            self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
            sender.setTranslation(CGPointZero, inView:self)
        default:
            break
        }
    }
}