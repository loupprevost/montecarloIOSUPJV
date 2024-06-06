//
//  MethodBrain.swift
//  MonteCarlo
//
//  Created by Loup Prévost on 30/11/2023.
//

import Foundation

struct MonteCarloBrain
{
    // Definition d'un point
    public struct Point
    {
        var x:CGFloat
        var y:CGFloat
        var distance:Bool
    }
    
    // Calcul distance entre 2 points
    private func calDist(X1: Double, Y1: Double, X2: Double, Y2: Double) -> Double {
        let xDiff = X2 - X1
        let yDiff = Y2 - Y1
        
        let dist = sqrt(xDiff * xDiff + yDiff * yDiff)
        return dist
    }
    
    // Création des coordonnées des points
    public func createPoints(nbPoints: Int) -> [Point] {
        var points: [Point] = []
        
        for _ in 0..<nbPoints {
            let randomX = CGFloat.random(in: 0...1)
            let randomY = CGFloat.random(in: 0...1)
            
            var newPoint = Point(x: randomX, y: randomY, distance:false)
            
            let distCenterCircle = calDist(X1:0,Y1:1,X2:randomX,Y2:randomY)
            
            if(distCenterCircle < 1)
            {
                newPoint.distance = true
            }
            
            points.append(newPoint)
        }
        return points
    }
    
    // Calcul approximatif de pi avec monte carlo
    public func calcPI(points: [Point]) -> Double {
        let totPoints = points.count
        var pointsInCircle = 0
        
        for point in points {
            if point.distance {
                pointsInCircle += 1
            }
        }
        
        let PICalc = 4.0 * Double(pointsInCircle) / Double(totPoints)
        
        return PICalc
    }
    
    
}
