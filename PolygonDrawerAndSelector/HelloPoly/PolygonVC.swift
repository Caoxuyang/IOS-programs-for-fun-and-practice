//
//  ViewController.swift
//  HelloPoly
//
//  Created by Cao Xuyang on 2018/2/20.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import UIKit

class PolygonVC: UIViewController, PolygonProtocol {
    @IBOutlet weak var sidesDisplay: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var PolygonView: PolygonView! {
        didSet {
            PolygonView.polygon = self
        }
    }
    
    //give it a default value
    var curSides: Int = 8 {
        didSet{
            updateUI()
        }
    }
    lazy var polygon: PolygonShape = PolygonShape(numberOfSides: curSides)
    
    let rect1 = CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: CGSize(width: UIScreen.main.bounds.size.width * 0.8, height: UIScreen.main.bounds.size.height * 0.8)
    )
    
    //delegation function
    func pointsInRect(rect: CGRect) -> [CGPoint]? {
        return polygon.pointsInRect(rect: rect, numberOfSides: curSides)
    }
    
    @IBAction func decreaseSides(_ sender: UIButton) {
        if curSides == 3 {
            return
        }
        increaseButton.isEnabled = true
        if curSides == 4 {
            decreaseButton.isEnabled = false
        }
        curSides -= 1
        polygon = PolygonShape(numberOfSides: curSides)
        sidesDisplay!.text = String(curSides)
    }
    
    @IBAction func increaseSides(_ sender: UIButton) {
        if curSides == 12 {
            return
        }
        decreaseButton.isEnabled = true
        if curSides == 11 {
            increaseButton.isEnabled = false
        }
        curSides += 1
        polygon = PolygonShape(numberOfSides: curSides)
        sidesDisplay!.text = String(curSides)
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.right:
            increaseSides(increaseButton)
        case UISwipeGestureRecognizerDirection.left:
            decreaseSides(decreaseButton)
        default:
            print("We only allow swipe left and right")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var swipeRecognizer: UISwipeGestureRecognizer!
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PolygonVC.swipe(_:)))
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRecognizer)
        updateUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func updateUI()
    {
        PolygonView.setNeedsDisplay()
    }
}

