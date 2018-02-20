//
//  ViewController.swift
//  GravityBubbles
//
//  Created by Cao Xuyang on 2018/1/24.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var GameView: UIView!
    private var gravity = UIGravityBehavior()
    private var collider = UICollisionBehavior()
    private var animator : UIDynamicAnimator?
    
    private struct Constants {
        static let BubbleSize = CGSize(width: 28, height: 28)
    }
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        print("\(sender.location(in: self.GameView))")
        dropBubble()
    }
    private func dropBubble(){
        var frame = CGRect()
        frame.origin = CGPoint.zero
        frame.size = Constants.BubbleSize
        let x = GameView.bounds.size.width * CGFloat(arc4random()) / CGFloat(UInt32.max)
        frame.origin.x = x
        let bubbleView = EllipseView(frame: frame)
        bubbleView.backgroundColor = UIColor.RandomColor()
       
        GameView.addSubview(bubbleView)
        collider.addItem(bubbleView)
        gravity.addItem(bubbleView)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        animator = UIDynamicAnimator(referenceView : GameView)
        animator?.addBehavior(gravity)
        animator?.addBehavior(collider)
        collider.translatesReferenceBoundsIntoBoundary = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class EllipseView: UIView{
    override init(frame : CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.gray
        layer.cornerRadius = frame.size.width / 2.0
        //layer.borderColor = UIColor.RandomColor().cgColor
        layer.borderWidth = 0.5
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("has not been initialed")
    }
    override var collisionBoundsType : UIDynamicItemCollisionBoundsType{
        return .ellipse
    }
   
}
extension UIColor{
    static func RandomColor() -> UIColor{
        let randomHue = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(hue: randomHue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}

