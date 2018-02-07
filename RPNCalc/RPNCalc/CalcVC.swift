//
//  ViewController.swift
//  RPNCalc
//
//  Created by Cao Xuyang on 2018/1/30.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import UIKit

class CalcVC: UIViewController {
    @IBOutlet var stackDisplay: [UILabel]!
    lazy var calcDisplay = stackDisplay.filter { $0.tag == 0 }.first!
    
    private var calcModel = CalcModel()
    private var inputMode = false
    var displayValues : [Double] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func operationPressed(_ sender: UIButton) {
        if inputMode {
            pushOperand()
        }
        if let operation = sender.currentTitle {
            displayValues = calcModel.performOperation(operation)
            if displayValues.count > 4 {
                for i in 0 ... 3{
                    let tempScreen = stackDisplay.filter { $0.tag == 3 - i }.first!
                    tempScreen.text = String(displayValues[displayValues.endIndex - 1 - i])
                }
            } else {
                let length = displayValues.count
                for i in 0 ... length-1{
                    let tempScreen = stackDisplay.filter { $0.tag == length - 1 - i }.first!
                    tempScreen.text = String(displayValues[displayValues.endIndex - 1 - i])
                }
                for i in length ... 3{
                    let tempScreen = stackDisplay.filter { $0.tag == i }.first!
                    tempScreen.text = " "
                }
            }
        }
    }
    
    @IBAction func pushOperand(_ sender: UIButton? = nil) {

        inputMode = false
        if let operand = calcDisplay.text {
            let num = Double(operand)
            displayValues = calcModel.pushOperand(num!)
            if displayValues.count > 4 {
                for i in 0 ... 3{
                    let tempScreen = stackDisplay.filter { $0.tag == 3 - i }.first!
                    tempScreen.text = String(displayValues[displayValues.endIndex - 1 - i])
                }
            } else {
                let length = displayValues.count
                for i in 0 ... length-1{
                    let tempScreen = stackDisplay.filter { $0.tag == length - 1 - i }.first!
                    tempScreen.text = String(displayValues[displayValues.endIndex - 1 - i])
                }
                for i in length ... 3{
                    let tempScreen = stackDisplay.filter { $0.tag == i }.first!
                    tempScreen.text = " "
                }
            }
        }
        
    }
    
    @IBAction func digitPressed(_ sender: UIButton) {
        //print("!!! " + #function)
        if let digit = sender.currentTitle{
            if inputMode{
                calcDisplay.text = calcDisplay.text! + digit
            } else{
                calcDisplay.text = digit;
                inputMode = true;
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

