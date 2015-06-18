//
//  Brick.swift
//  Breakout_Daniel_Bram
//
//  Created by Student on 05-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import Foundation
import UIKit

class Brick: UIView{
    var specialPowerUp: String = "none"
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(rect: rect)
        UIColor.greenColor().setFill()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 0.5
        path.fill()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func retrieveAlpha() -> CGFloat{
        return alpha
    }
}