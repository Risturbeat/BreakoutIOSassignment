//
//  TestCalculatorBrain.swift
//  Calculator
//
//  Created by Mad Max on 26/02/15.
//  Copyright (c) 2015 HAN University of Applied Sciences. All rights reserved.
//

import XCTest

class TestCalculatorBrain: XCTestCase {

    func testBasicOperation(){
        let brain = CalculatorBrain()
        
        func testFunction<T>(operation: T -> Double?, #input: T, #result: Double){
            if let actual = operation(input){
                XCTAssertEqual(actual,result)
            }else{
                XCTFail("result should not be nil")
            }
        }
        var result = brain.pushOperand(9.0)
        
        testFunction(brain.pushOperand, input: 9.0, result: 9.0)
        testFunction(brain.pushOperand, input: 6.0, result: 6.0)
        testFunction(brain.performOperation, input: "+", result: 15.0)
        XCTAssertEqual(result!, 8.0)
    }
    
    //pushoperand
    //publieke functies
    //na de init opstack inspecteren
    //opgeven van een key en value checken.
    //description van op
}
