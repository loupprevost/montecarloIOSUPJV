//
//  DessinView.swift
//  MonteCarlo
//
//  Created by Loup Prévost on 30/11/2023.
//

import Foundation
import UIKit

@IBDesignable
class MonteCarloView: UIView
{
    var points: [MonteCarloBrain.Point] = []
    
    // Longueur de la coté du carré
    var squareSide: CGFloat = 300.0
    
    override func draw(_ rect: CGRect) {
        // Origines du carré (marges entre l'UIView et le carré dessiné)
        let squareX = (rect.width - squareSide)/2
        let squareY = (rect.height - squareSide)/2
   
        // Dessin du carré
        let square = UIBezierPath(rect: CGRect(x: squareX, y: squareY, width: squareSide, height: squareSide))
        UIColor.black.setStroke()
        square.lineWidth = 0.5
        square.stroke()
        
        // Dessin des points
        drawPoints(margeX: squareX, margeY: squareY)
    }
    
    // Dessin des points
    public func drawPoints(margeX: Double, margeY: Double)
    {
        for point in points {
            let center = CGPoint(x: (point.x * squareSide) + margeX, y: (point.y * squareSide) + margeY)
            let circle = UIBezierPath(arcCenter: center, radius: 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            if(point.distance == true)
            {
                UIColor.green.setFill()
            }
            else
            {
                UIColor.red.setFill()
            }
            circle.fill()
        }
    }
}

