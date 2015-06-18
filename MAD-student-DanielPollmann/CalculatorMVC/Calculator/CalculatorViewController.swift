//
//  ViewController.swift
//  Calculator
//
//  Created by Mad Max on 05/02/15.
//  Copyright (c) 2015 HAN University of Applied Sciences. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var stackLabel: UILabel!
    
    var userIsTypingANumber = false
    var userTypedDot = false
    var shouldAddToHistory = true
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        if userIsTypingANumber{
            display.text = display.text! + digit
        }else{
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
    
    @IBAction func saveVariableValue(sender: UIButton) {
        // source http://sketchytech.blogspot.nl/2014/08/swift-pure-swift-method-for-returning.html
        if let variable = last(sender.currentTitle!){
            if displayValue != nil{
                brain.variableValues["\(variable)"] = displayValue //store the value
                if let result = brain.evaluate(){
                    displayValue = result
                }else{
                    displayValue = nil
                }
            }
        }
        userIsTypingANumber = false
    }
   
    @IBAction func pushVariableToStack(sender: UIButton) {
        if userIsTypingANumber{
            enter()
        }
        
        if let result = brain.pushOperand(sender.currentTitle!){
            displayValue = result
        }else{
            displayValue = nil
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsTypingANumber{
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = nil
            }
            history.text = history.text! + operation + ", "
            updateStackLabel()
        }
        shouldAddToHistory = false
        showEqualsSign()
    }
    
    @IBAction func executePlusMinus(sender: UIButton) {
        var valueToDisplay = (displayValue! * -1).description
        removeRange(&valueToDisplay, valueToDisplay.rangeOfString(".0")!)
        display.text = valueToDisplay
        userIsTypingANumber = true
    }
    
    func showEqualsSign(){
        if history.text!.rangeOfString("=") != nil{
            history.text!.removeRange(history.text!.rangeOfString("=")!)
        }
        shouldAddToHistory = true
        addToHistory("=")
        
    }
    
    @IBAction func enter() {
        addToHistory(display.text!)
        
        userIsTypingANumber = false
        userTypedDot = false
        
            if let result = brain.pushOperand(displayValue!){
                displayValue = result
            }else{
                displayValue = nil
            }
        updateStackLabel()
    }
    
    func addToHistory(value : String){
        if shouldAddToHistory{
            history.text = brain.description != "" ? brain.description + " =" : ""
        }
        shouldAddToHistory = true
    }
    
    func updateStackLabel(){
        println("Opstack in updatelabel \(brain.getCurrentOpStack())")
        stackLabel.text = "Operand stack: " + "\(brain.getCurrentOpStack())"
    }
    
    var displayValue: Double? {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            if (newValue != nil){
                display.text =  "\(newValue!)"
                userIsTypingANumber = false
            }else{
                display.text = " "
            }
        }
    }
    
    @IBAction func clear() {
        history.text!.removeAll(keepCapacity: false)
        brain = CalculatorBrain()
        stackLabel.text = "Operand stack:"
        display.text = nil
    }
    
    @IBAction func backspace(sender: UIButton) {
        display.text = dropLast(display.text!)
        if countElements(display.text!) < 1 {
            display.text = "0"
            userIsTypingANumber = false
        }
    }
}

