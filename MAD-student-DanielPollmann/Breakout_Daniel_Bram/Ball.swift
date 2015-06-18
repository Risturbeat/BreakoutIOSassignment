//
//  Ball.swift
//  Breakout_Daniel_Bram
//
//  Created by Student on 05-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class Ball: UIView {
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        UIColor.cyanColor().setFill()
        path.fill()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clearColor()
    }
}





