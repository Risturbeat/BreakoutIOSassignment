//
//  SecondViewController.swift
//  Breakout_Daniel_Bram
//
//  Created by Student on 05-06-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var brickAmountLabel: UILabel!
    @IBOutlet weak var lifeAmountLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var brickSlider: UISlider!
    @IBOutlet weak var lifeStepper: UIStepper!
    @IBOutlet weak var paddleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var speed: UISwitch!
    
    @IBAction func brickAmountChanged(sender: UISlider) {
        brickAmountLabel.text = "\(Int(sender.value))"
        defaults.setObject(Int(sender.value), forKey: "brickAmount")
    }
    @IBAction func lifeAmountChanged(sender: UIStepper) {
        lifeAmountLabel.text = "\(Int(sender.value))"
        defaults.setObject(Int(sender.value), forKey: "lifeAmount")
    }
    @IBAction func speedChanged(sender: UISwitch) {
        if sender.on{
            speedLabel.text = "Fast"
        } else{
            speedLabel.text = "Slow"
        }
        defaults.setObject(sender.on, forKey: "speed")
    }
    @IBAction func paddleSizeChanged(sender: UISegmentedControl) {
        var paddleScale: Double = 0
        switch(sender.selectedSegmentIndex){
        case 0:
            paddleScale = 2/3
            break;
        case 1:
            paddleScale = 1
            break;
        case 2:
            paddleScale = 4/3
            break;
        default:
            paddleScale = 1
            break;
        }
        defaults.setObject(paddleScale, forKey: "paddleScale")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brickAmountLabel.text = "\(Int(brickSlider.value))"
        lifeAmountLabel.text = "\(Int(lifeStepper.value))"
        
        var paddleScale: Int = 1
        switch (paddleSegmentedControl.selectedSegmentIndex){
            case 0:
                paddleScale = 2/3
                break;
            case 1 :
                paddleScale = 1
                break;
            case 2 :
                paddleScale = 4/3
                break;
        default:
            break;
        }
        speedLabel.text = "Slow"
        
        defaults.setObject(Int(brickSlider.value), forKey: "brickAmount")
        defaults.setObject(Int(lifeStepper.value), forKey: "lifeAmount")
        defaults.setObject(paddleScale, forKey: "paddleScale")
        defaults.setObject(speed.on, forKey:"speed")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

