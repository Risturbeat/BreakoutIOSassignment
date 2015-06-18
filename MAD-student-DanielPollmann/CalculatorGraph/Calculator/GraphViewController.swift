//
//  GraphViewController.swift
//  Calculator
//
//  Created by Mad Max on 20/03/15.
//  Copyright (c) 2015 HAN University of Applied Sciences. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource{
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target:graphView, action: "moveGraph:"))
            let tapGesture = UITapGestureRecognizer(target: graphView, action:"setGraphCenterToTappedPosition:")
            tapGesture.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapGesture)
            
            //rshankar.com/uitgesturerecognizer-in-swift
            //graphView.addGestureRecognizer(UITapGestureRecognizer(target: graphView, action: "setGraphCenterToTappedPosition:"))
        }
    }
    
    private var brain = CalculatorBrain()
    
    typealias PropertyList = AnyObject
    var whatToDraw : PropertyList{
        get {
            return brain.program
        }
        set{
            brain.program = newValue
        }
    }
    
    
    func y(x: CGFloat) -> CGFloat?{
        //The variable M is used as the "independent variable", hence it must be set
        brain.variableValues["M"] = Double(x)
        //I can use brain.evaluate since in the GraphViewControllers brain there is no other variable stored than M
        //I cannot return it instantly though, since I have to check if it can actually be evaluated
        if let y = brain.evaluate(){
            return CGFloat(y)
        }
        return nil
    }
}
