//
//  GraphView.swift
//  Calculator
//
//  Created by Mad Max on 20/03/15.
//  Copyright (c) 2015 HAN University of Applied Sciences. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class{
    func y(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource : GraphViewDataSource?
    
    @IBInspectable
    var scale: CGFloat = 50 {didSet {setNeedsDisplay() } }
    var graphCenter: CGPoint = CGPoint(){
        didSet{
            setGraphCenterToCenter = false
            setNeedsDisplay()
        }
    }

    
    var lineWidth: CGFloat = 2.0{ didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.redColor() { didSet { setNeedsDisplay() } }
    
    var setGraphCenterToCenter : Bool = true { didSet { if setGraphCenterToCenter{ setNeedsDisplay() } } }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        if setGraphCenterToCenter{
            graphCenter = center
        }
        
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin:graphCenter, pointsPerUnit: scale)
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        var firstValidValue = true
        var point = CGPoint() // I need a point to draw to
      
        
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            point.x = CGFloat(i) / contentScaleFactor // Keeping in mind the scale factor that is used everywhere
            if let y = dataSource?.y((point.x - graphCenter.x) / scale){  //I have to provide an "x", but I have to respect the origin and take into account the scale
                if !y.isNormal && !y.isZero {
                    firstValidValue = true
                    continue
                }
                point.y = graphCenter.y - y * scale //Again respect the origin and take into account the scale
                if firstValidValue {
                    path.moveToPoint(point)
                    firstValidValue = false
                }else{
                    path.addLineToPoint(point)
                }
            }else{
                firstValidValue = true
            }
        }
        path.stroke()
        
    }
    
    func moveGraph(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Ended:
            fallthrough
        case .Changed:
            let translation = sender.translationInView(self)
            graphCenter.x += translation.x
            graphCenter.y += translation.y
            sender.setTranslation(CGPointZero, inView:self)
        default:
            break
        }
    }
    
    func scale(sender: UIPinchGestureRecognizer){
        if sender.state == .Changed{
            scale *= sender.scale
            sender.scale = 1
        }
    }
    func setGraphCenterToTappedPosition(sender:UITapGestureRecognizer){
        if sender.state == .Ended{
            graphCenter = sender.locationInView(self)
        }
    }

}
