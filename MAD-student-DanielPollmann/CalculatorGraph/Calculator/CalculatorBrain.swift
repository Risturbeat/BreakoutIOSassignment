//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mad Max on 12/02/15.
//  Copyright (c) 2015 HAN University of Applied Sciences. All rights reserved.
//

import Foundation


class CalculatorBrain{
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    var variableValues = [String:Double]()
    
    var description: String {
        get{
            var (result,ops) = ("",opStack)
            while ops.count > 0{
                var current:String?
                (current,ops) = description(ops)
                result = result == "" ? current! : "\(current!), \(result)"
            }
            return result
        }
    }
    
    enum Op : Printable{
        case Operand (Double)
        case UnaryOperation (String, Double-> Double)
        //In order for the BinaryOperation to be able to work with it's precedence, a precedence will have to be given. Represented as the 2nd Parameter
        case BinaryOperation (String, Int, (Double,Double) -> Double)
        case Variable(String)
        
        var description: String {
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol

                case .BinaryOperation(let symbol,_ , _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return opStack.map { $0.description}
        }set{
            if let opSymbols = newValue as? Array<String>{
                var newOpStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol]{
                        newOpStack.append(op)
                    }else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
                        newOpStack.append(.Operand(operand))
                    }else{
                        newOpStack.append(.Variable(opSymbol))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    init(){
        func learnop (op:Op){
            knownOps[op.description]=op
        }
        knownOps["×"] = Op.BinaryOperation("×", 2, *)
        knownOps["÷"] = Op.BinaryOperation("÷",2) {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", 1, +)
        knownOps["−"] = Op.BinaryOperation("−",1) {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
    }
    
    func pushOperand( operand: Double)->Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) ->Double?{
        opStack.append(Op.Variable(symbol)) // operands get pushed onto the opStack, but opStack needs a new case for this to be possible
        return evaluate()
    }
    
    func getCurrentOpStack() ->[Op]{
        return opStack
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return(operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand),operandEvaluation.remainingOps)
                }
            case .BinaryOperation (_,_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            //Needs a new case: .Variable
            case .Variable(let symbol):
                //Check whether or not the Variable contains a value
                if let value = variableValues[symbol]{
                    //if so, return the value that is in there
                    return(variableValues[symbol],remainingOps)
                }
                
                return (nil,remainingOps)
                
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double?{
        let(result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    
    func performOperation(symbol: String)-> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func description(ops:[Op]) -> (result:String?, remainingOps:[Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let value):
                return("\(value)",remainingOps)
            case .Variable(let variable):
                return (variable, remainingOps)
            case .UnaryOperation(let operation, let operand):
                let operandEvaluation = description(remainingOps)
                if let value = operandEvaluation.result{
                    return ("\(operation)(\(value))", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let operation, let precedence, let operand):
                let op1Evaluation = description(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = description(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                            return ("(\(operand2) \(operation) \(operand1))",op2Evaluation.remainingOps)
                        }
                    
                }
            }
        }
        //Missing operand
        return ("?",ops)
    }

}