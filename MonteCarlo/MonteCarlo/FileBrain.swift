//
//  FileBrain.swift
//  MonteCarlo
//
//  Created by Loup Prévost on 24/12/2023.
//

import Foundation
struct FileBrain
{
    public var BddMonteCarloFileName = "BDDMonteCarlo.txt"
    
    // Fonction pour le chemin du fichier
    private func documentDirectory() -> String {
        let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return documentDirectory[0].path
    }
    
    // Fonction pour le chemin du fichier
    private func append(toPath path: String, withPathComponent pathComponent: String) -> String {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        return "Erreur"
    }
    
    // Fonction permettant d'ecrire un text dans un fichier
    private func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        let filePath = append(toPath: directory,
                              withPathComponent: fileName)
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Erreur", error)
            return
        }
    }
    
    // Fonction permettant de lire et renvoyer le contenu d'un fichier
    public func read(fileName: String) -> String {
        let filePath = append(toPath: documentDirectory(),
                              withPathComponent: fileName)
        do {
            let savedString = try String(contentsOfFile: filePath,
                                         encoding: .utf8)
            return savedString
        } catch {
            return "Erreur de lecture de " + fileName
        }
    }
    
    // Fonction permettant de vider un fichier
    func reset(fileName: String) {
        let emptyContent = ""
        save(text: emptyContent, toDirectory: documentDirectory(), withFileName: fileName)
    }

    
    // Fonction permettan de mettre à jour le fichier de BDD de monteCarlo si nécessaire après une nouveau calcul de monteCarlo
    public func updateMonteCarloBdd(nbPoints: Int, piAppro: Double) {
        let fileContent = read(fileName: BddMonteCarloFileName)
        var lines = fileContent.components(separatedBy: .newlines)
        
        // Variable si une line avec ce nbPoints est trouvée
        var lineFound: Bool = false

        for index in 0..<lines.count
        {
            let line = lines[index]
            
            if line.hasPrefix("/\(nbPoints)=")
            {
                lineFound = true
                let components = line.components(separatedBy: "=")
                if components.count > 1
                {
                    // On récupère l'approximation de pi déjà enregistré dans la BDD
                    let piValue = components[1].trimmingCharacters(in: .whitespaces)
                    if let existingPi = Double(piValue)
                    {
                        // On calcul l'ecart entre ce existingPi et Pi
                        let existingDifference = abs(existingPi - Double.pi)
                        
                        // On calcul da l'ecart entre ce piAppro et Pi
                        let newDifference = abs(piAppro - Double.pi)
                        
                        if existingDifference > newDifference {
                            lines[index] = "/" + String(nbPoints) + "=" + String(piAppro)
                        }
                    }
                }
                break
            }
        }
        
        // Si ce nbPoint n'est pas déjà dans la BDD, on l'ajoute dans une nouvelle ligne
        if(lineFound == false)
        {
            lines.append("/\(nbPoints)=\(piAppro)")
        }
        
        let updatedContent = lines.joined(separator: "\n")
        save(text: updatedContent, toDirectory: documentDirectory(), withFileName: BddMonteCarloFileName)
    }
    
    // Fonction permettant de récupérer la meilleure approximation de pi dans la BDD et son nbPoint associé
    public func getBestPiAppro(fileName: String) -> [String] {
        let fileContent = read(fileName: BddMonteCarloFileName)
        let lines = fileContent.components(separatedBy: .newlines)

        var bestPiApproTabl: [String] = []

        for line in lines {
            if line.hasPrefix("/")
            {
                let components = line.components(separatedBy: "=")
                if components.count > 1
                {
                    if let piApproOfLine = Double(components[1])
                    {
                        // Premier résultat trouvé
                        if bestPiApproTabl.isEmpty
                        {
                            bestPiApproTabl.append( String(components[0].dropFirst()))
                            bestPiApproTabl.append(components[1])
                        }
                        else
                        {
                            if let piApproOfTabl = Double(bestPiApproTabl[1])
                            {
                                // Si approximation meilleure que celle déjà enregistrée
                                if(abs(piApproOfTabl - Double.pi) > abs(piApproOfLine - Double.pi))
                                {
                                    bestPiApproTabl[0] = String(components[0].dropFirst())
                                    bestPiApproTabl[1] = components[1]
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Si BDD vide
        if bestPiApproTabl.isEmpty
        {
            bestPiApproTabl.append("0")
            bestPiApproTabl.append("0")
        }
        
        return bestPiApproTabl
    }
}


