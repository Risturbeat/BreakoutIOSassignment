//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mad Max on 12/02/15.
//  Copyright (c) 2015 HAN University of Applied Sciences. All rights reserved.
//

import Foundation

enum Op{
    case something
    case Operand (Double)
    case Operator (String, Double-> Double)
}

var opStack = [Op]()
private var knownOps = [String:Op]()

func checkEnum(ops: [Op]) -> (result: Double?, remainingOps:[Op]){
    if !ops.isEmpty{
        var remainingOps = ops
        let op = remainingOps.removeLast()
        
                switch op {
        case .Operand: println("operand")
        default:break
        }
    }
    return (nil,ops)
}