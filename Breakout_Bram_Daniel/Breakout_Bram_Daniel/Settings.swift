//
//  Settings.swift
//  Breakout_Daniel_Bram
//
//  Created by Student on 16-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import Foundation

protocol SettingsDelegate{
    func brickAmountChanged(newAmount: Int)
    func lifeAmountChanged(newAmount:Int)
    func paddleWidthChanged(newAmount:Int)
}

class Settings {
    var delegate : SettingsDelegate?
    
    var bricks: Int = 25{
        didSet{
            delegate?.brickAmountChanged(self.bricks)
        }
    }
    
    var amountOfLives: Int = 3{
        didSet{
            delegate?.lifeAmountChanged(self.amountOfLives)
        }
    }
    
    var paddleSize: Int = 120{
        didSet{
            delegate?.paddleWidthChanged(self.paddleSize)
        }
    }
}