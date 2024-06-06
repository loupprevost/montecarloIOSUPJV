//
//  DessinView.swift
//  MonteCarlo
//
//  Created by Loup Prévost on 30/11/2023.
//

import Foundation
import UIKit

@IBDesignable
class GraphView: UIView {
    var normalizePoints: [GraphBrain.NormalizePoint] = []
    
    // Définition des variables
    var graphWidth: CGFloat = 0.0
    var graphHeight: CGFloat = 0.0
    
    var margeX = 0.0
    var margeY = 0.0

    override func draw(_ rect: CGRect) {
        // Dimension du graphique
        graphWidth = rect.width - 100
        graphHeight = rect.height - 25
        
        // Marge du graphique avec l'UIView
        margeX = ((rect.width - graphWidth) / 2) + 25 // ajout de 25 pour ecrire les nbPoints
        margeY = (rect.height - graphHeight) / 2
        
        let square = UIBezierPath(rect: CGRect(x: margeX, y: margeY, width: graphWidth, height: graphHeight))
        UIColor.black.setStroke()
        square.lineWidth = 0.5
        square.stroke()

        // Dessin de la ligne de pi (ligne verte)
        drawPiLine(in: rect)
        // Dessin des points repésentant la meilleure approximation de pi du nbPoint en ordonnée
        drawPoints(in: rect)
    }

    // Dessin des points
    func drawPoints(in rect: CGRect) {
        let pointsCount = normalizePoints.count
        let spaceBetweenPoints = graphHeight / Double(pointsCount)
        
        // Parcourir tous les points à dessiner
        for i in 1..<normalizePoints.count {
            let normalizePoint = normalizePoints[i]
            
            // Calcul des coordonnées pour le point actuel
            let xPoint = margeX + (normalizePoint.normalizeValue * graphWidth)
            let yPoint = margeY + (spaceBetweenPoints * Double(i))
            
            // Point central pour le cercle
            let center = CGPoint(x: xPoint, y: yPoint)
            
            // Création du cercle représentant le point
            let circle = UIBezierPath(arcCenter: center, radius: 2.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            
            UIColor.red.setFill()
            
            // Remplissage du cercle
            circle.fill()
            
            // Écriture du nbPoints
            var text = String(normalizePoint.nbPoints)
            // Parametrage du texte
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11.0),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            let textSize = text.size(withAttributes: attributes)
            
            // Position
            var textRect = CGRect(x: (textSize.width / 2) + (margeX / 4), y: margeY + (spaceBetweenPoints * Double(i)) - (textSize.height / 2), width: textSize.width, height: textSize.height)
            
            text.draw(in: textRect, withAttributes: attributes)
            
            if(normalizePoint.normalizeValue == 0 || normalizePoint.normalizeValue == 1)
            {
                // Écrire l'approximation en haut
                text = String(normalizePoint.piAppro)
                // Position
                let textRect = CGRect(x: xPoint - (textSize.width / 2), y: 0, width: textSize.width, height: textSize.height)
                
                text.draw(in: textRect, withAttributes: attributes)
            }
            
            // Écrire l'approximation
            text = String(normalizePoint.piAppro)
            // Position
            textRect = CGRect(x: xPoint + 3, y: yPoint - 5, width: textSize.width, height: textSize.height)
            
            text.draw(in: textRect, withAttributes: attributes)
        }
    }

    
    func drawPiLine(in rect: CGRect){
        // Récuperation du pi normalisé qui est toujours en prrmière position
        let normalizePi = normalizePoints[0]
        
        // Initialisation du chemin
        let path = UIBezierPath()
        
        var startPoint = CGPoint(x: 0, y: 0)
        
        // Point d'arrivée de la ligne (à droite)
        var endPoint = CGPoint(x: 0, y: 0)
        
        // S'il n'y a que pi dans le tableau
        if(normalizePoints.count == 1)
        {
            startPoint = CGPoint(x: margeX + graphWidth/2, y: margeY)
            endPoint = CGPoint(x: margeX + graphWidth/2, y: margeY + graphHeight)
        }
        else
        {
            startPoint = CGPoint(x: margeX + (normalizePi.normalizeValue * graphWidth), y: margeY)
            endPoint = CGPoint(x: margeX + (normalizePi.normalizeValue * graphWidth), y: margeY + graphHeight)
        }
        
        // Définition de la ligne horizontale
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        // Configuration de la couleur et de l'épaisseur de la ligne
        UIColor.green.setStroke()
        path.lineWidth = 2.0
        
        // Dessiner le chemin
        path.stroke()
        
        // Écrire π
        let text = "π"
        
        // Parametrage du texte
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11.0),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        let textSize = text.size(withAttributes: attributes)
        
        // Position
        let textRect = CGRect(x: startPoint.x - (textSize.width / 2), y: 0, width: textSize.width, height: textSize.height)
        
        text.draw(in: textRect, withAttributes: attributes)
    }
}
