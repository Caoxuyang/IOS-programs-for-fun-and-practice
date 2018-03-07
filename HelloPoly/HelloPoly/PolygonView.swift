//
//  PolygonView.swift
//  HelloPoly
//
//  Created by Cao Xuyang on 2018/2/20.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import Foundation
import UIKit

protocol PolygonProtocol: class{
    func pointsInRect(rect: CGRect) -> [CGPoint]?
}

class PolygonView: UIView {
    weak var polygon: PolygonProtocol?
    var fillColor: UIColor = UIColor.clear
    var strokeColor: UIColor = UIColor.black
    var lineWidth: CGFloat = 2.5

    override func draw(_ rect: CGRect) {
        //draw vertices
        
        if let vertices = polygon?.pointsInRect(rect: rect) {
            var path = UIBezierPath()
            for vertex in vertices {
                path.append(UIBezierPath(arcCenter: vertex, radius: 3.0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true))
            }
            fillColor.setFill()
            path.fill()
            // join these vertices
            path = UIBezierPath()
            path.move(to: vertices[0])
            for vertex in vertices[1..<vertices.count] {
                path.addLine(to: vertex)
            }
            path.close()
            strokeColor.setStroke()
            path.lineWidth = CGFloat(lineWidth)
            path.stroke()
        }
    }
    
}
