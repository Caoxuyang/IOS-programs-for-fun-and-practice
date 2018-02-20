//
//  PolygonShape.swift
//  HelloPoly
//
//  Created by Cao Xuyang on 2018/2/20.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import Foundation
import CoreGraphics
class PolygonShape {
    var numberOfSides: Int
    init(numberOfSides: Int){
        self.numberOfSides = numberOfSides
    }
    
    func pointsInRect(rect: CGRect, numberOfSides: Int) -> [CGPoint]? {
        let polygonPoints = { (rect: CGRect, numberOfSides: Int) -> [CGPoint] in
            let center = rect.center
            let radius = min(rect.size.width, rect.size.height) / 2.0
            let arc = 2 * CGFloat.pi / CGFloat(numberOfSides)
            var vertexArray = [CGPoint]()
            for i in 0..<numberOfSides {
                var vertex = center
                vertex.x += cos(arc * CGFloat(i) - 2 * CGFloat.pi) * radius
                vertex.y += sin(arc * CGFloat(i) - 2 * CGFloat.pi) * radius
                vertexArray.append(vertex)
            }
            return vertexArray
        }
        let result = polygonPoints(rect, numberOfSides)
        return result
    }
    
}
extension CGRect {
    var center: CGPoint {
        let origin = self.origin
        let height = self.height
        let width = self.width
        return CGPoint(x: origin.x + width/2, y: origin.y + height/2)
    }
}
