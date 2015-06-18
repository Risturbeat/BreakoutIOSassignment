//
//  ViewController.swift
//  Calculator
//
//  Created by Mad Max on 05/02/15.
//  Copyright (c) 2015 HAN University of Applied Sciences. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var stackLabel: UILabel!
    
    var userIsTypingANumber = false
    var userTypedDot = false
    var shouldAddToHistory = true
    var operandStack = Array<Double>()
    var userTypedStack = Array<Double>()
    var brain = CalculatorBrain()

    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        if userIsTypingANumber{
            println("User is typing and appending")
            display.text = display.text! + digit
        }else{
            println("User is not typting")
            display.text = digit
            userIsTypingANumber = true
        }
    }
    
    @IBAction func appendDot(sender: UIButton){
        let digit = sender.currentTitle!
        
        if userIsTypingANumber && digit == "." && display.text!.rangeOfString(".") == nil {
                display.text = display.text! + digit
        }else{
            if !userIsTypingANumber{
                display.text = "0" + digit
                userIsTypingANumber = true
            }
           
        }
    }
    
    @IBAction func addPi(sender: UIButton) {
        if userIsTypingANumber{
            enter()
        }
            display.text = "\(M_PI)"
            enter()
        }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsTypingANumber{
            enter()
        }
        
        history.text = history.text! + operation + ", "
        shouldAddToHistory = false
        
        switch operation{
        case "×":performOperation { $0 * $1 }
            
        case "÷":
            if(operandStack.last != 0){ //cannot divide by 0!!
                performOperation { $1 / $0 }
            }else{
                operandStack.removeLast()
            }
        case "+":performOperation { $0 + $1 }
            
        case "−":performOperation { $1 - $0 }
            
        case "√":performOperation {sqrt($0)}
            
        case "sin":performOperation {sin($0)}
        
        case "cos": performOperation{cos($0)}
         
        default:break
        }
    }
    
    func performOperation(operation: (Double,Double) ->Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            showEqualsSign()
            shouldAddToHistory = false
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double){
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            showEqualsSign()
            shouldAddToHistory = false
            enter()
        }
    }
    
    @IBAction func executePlusMinus(sender: UIButton) {
        var valueToDisplay = (displayValue * -1).description
        removeRange(&valueToDisplay, valueToDisplay.rangeOfString(".0")!)
        display.text = valueToDisplay
        userIsTypingANumber = true
    }
    
    func showEqualsSign(){
        if history.text!.rangeOfString("=") != nil{
            history.text!.removeRange(history.text!.rangeOfString(", =")!)
        }
        shouldAddToHistory = true
        addToHistory("=")
        
    }
    
    @IBAction func enter() {
        addToHistory(display.text!)
        
        userIsTypingANumber = false
        userTypedDot = false
        
        operandStack.append(displayValue)
        updateStack()
        println(" operandSTack = \(operandStack)")
    }
    
    func addToHistory(value : String){
        if shouldAddToHistory{
            switch value{
                case "\(M_PI)": history.text = history.text! + "3.14" + ", "
                case "=": history.text = history.text! + value + ", "
                default: history.text = history.text! + display.text! + ", "
            }
        }
        shouldAddToHistory = true
    }
    
    func updateStack(){
        stackLabel.text = "Operand stack: " + ""
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
           display.text =  "\(newValue)"
            userIsTypingANumber = false
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        operandStack.removeAll(keepCapacity: false)
        history.text!.removeAll(keepCapacity: false)
        stackLabel.text = "Operand stack:"
        display.text = "0"
    }
    
    @IBAction func backspace(sender: UIButton) {
        display.text = dropLast(display.text!)
        if countElements(display.text!) < 1 {
            display.text = "0"
            userIsTypingANumber = false
        }
    }
}

