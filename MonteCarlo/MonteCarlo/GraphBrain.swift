//
//  GraphBrain.swift
//  MonteCarlo
//
//  Created by Loup Prévost on 24/12/2023.
//

import Foundation

import Foundation

struct GraphBrain
{
    let fileBrain = FileBrain()
    
    // Definition d'un point
    public struct NormalizePoint {
        var nbPoints: Int
        var piAppro: Double
        var normalizeValue: Double
    }
    
    // Fonction permettant de récupéré chaque approximation de pi dans la BDD, et renvoyé un tableau NormalizePoint
    // contenant chaque nbPoint, son meilleur piAppro et ce piAppro normaliser entre 0 et 1 avec tous les piAppro de la BDD
    // Le premier NormalizePoint du tableau retourné est toujours le véritable Pi avec sa normalisation
    func normalizeBddMonteCarloData() -> [NormalizePoint] {
        let fileContent = fileBrain.read(fileName: fileBrain.BddMonteCarloFileName)
        var pointsArray: [NormalizePoint] = []
        
        let lines = fileContent.components(separatedBy: .newlines)
        
        for line in lines {
            let components = line.components(separatedBy: "=")
            if components.count > 1 {
                var nbPointsString = components[0].trimmingCharacters(in: .whitespaces)
                let normalizeValueString = components[1].trimmingCharacters(in: .whitespaces)
                
                // Check si la ligne commence par "/"
                if nbPointsString.hasPrefix("/") {
                    // Si oui, enlève le "/"
                    nbPointsString.removeFirst()
                }
                
                if let nbPoints = Int(nbPointsString), let normalizeValue = Double(normalizeValueString) {
                    let point = NormalizePoint(nbPoints: nbPoints, piAppro: normalizeValue, normalizeValue: normalizeValue)
                    pointsArray.append(point)
                }
            }
        }
        
        // Ajout d'une cellule supplémentaire avec nbPoints=0, normalizeValue=pi, pi=true
        let piValue = Double.pi
        let additionalPoint = NormalizePoint(nbPoints: 0, piAppro: piValue,normalizeValue: piValue)
        pointsArray.append(additionalPoint)
        
        // Trouver la valeur la plus petite et la plus grande dans normalizeValue
        let normalizeValues = pointsArray.map { $0.normalizeValue }
        let smallestValue = normalizeValues.min() ?? 0
        let highestValue = normalizeValues.max() ?? 1
        
        // Normaliser les valeurs entre 0 et 1 dans pointsArray
        for index in 0..<pointsArray.count {
            let normalizedValue = (pointsArray[index].normalizeValue - smallestValue) / (highestValue - smallestValue)
            pointsArray[index].normalizeValue = normalizedValue
        }
        
        // Trier le tableau par ordre croissant de nbPoints
        // (pi se retrouve dans la première cellule compte tenu de son nbPoint de 0)
        pointsArray.sort { $0.nbPoints < $1.nbPoints }
        
        return pointsArray
    }

}
