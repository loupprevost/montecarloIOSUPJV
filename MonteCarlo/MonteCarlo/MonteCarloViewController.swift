//
//  ViewController.swift
//  MonteCarlo
//
//  Created by Loup Prévost on 30/11/2023.
//

import UIKit

class MonteCarloViewController: UIViewController {
    
    private var monteCarloBrain = MonteCarloBrain()
    private var fileBrain = FileBrain()
    
    // Tableau de 2 cellules contenant la meilleure approximation de pi et son nbPoints
    private var bestPiApproTabl: [String] = []
    
    // Label de la meilleur approximation de pi et son nbPoints
    @IBOutlet weak var piApproBest: UILabel!
    @IBOutlet weak var nbPointsBest: UILabel!
    
    // Nombre de points (par le slider)
    private var nbPointInt = 1000
    
    // Valeur de pi calculé par MonteCarlo
    private var valPIValue = 0.0
    
    @IBOutlet weak var monteCarloView: MonteCarloView!
    
    // Label du nombre de points (par le slider)
    @IBOutlet weak var nbPointLabel: UILabel!
    
    // Label du pi calculé par monteCarlo
    @IBOutlet weak var valPILabel: UILabel!
    
    // Lorsque l'on glisse le slider, le nombre de points s'actualise avec un pas de 1000
    @IBAction func sliderNbPoints(_ sender: UISlider) {
        nbPointInt = Int(Int(sender.value) / 1000) * 1000
        nbPointLabel.text = String(nbPointInt)
    }
    
    // ========== Lorsque l'on lâche le slider ou du clique du bouton, lancement de la fonction doMonteCarlo ==========
    @IBAction func sliderCalc(_ sender: UISlider) {
        doMonteCarlo()
    }
    @IBAction func MCButton(_ sender: UIButton) {
        doMonteCarlo()
    }
    // ======================================
    
    // Actualisation de l'affichage de la meilleur approximation de Pi dans la BDD
    func actuBestPiAppro()
    {
        bestPiApproTabl = fileBrain.getBestPiAppro(fileName: "BDDMonteCarlo.txt")
        nbPointsBest.text = bestPiApproTabl[0]
        piApproBest.text = bestPiApproTabl[1]
    }
    
    
    // MonteCarlo est calculé, enregistrement dans la BDD et actualisation de la meilleure approximation de pi
    func doMonteCarlo()
    {
        // Envoi des données des points à la View pour le dessin de monteCarlo
        monteCarloView.points = monteCarloBrain.createPoints(nbPoints: nbPointInt)
        
        // Calcul de valeur de l'approximation Pi
        valPIValue = monteCarloBrain.calcPI(points: monteCarloView.points)
        
        // Affichage de l'approximation de Pi
        valPILabel.text = String(valPIValue)
        
        monteCarloView.setNeedsDisplay()
        
        // Mise à jour si nécessaire du fichier BDD
        fileBrain.updateMonteCarloBdd(nbPoints: nbPointInt, piAppro: valPIValue)
        
        actuBestPiAppro()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actuBestPiAppro()
    }
    
    // Rechargement de la meilleure approximation de pi lors de l'arrivé sur la page
    // (au cas où on vide la BDD précédemment)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actuBestPiAppro()
    }
}

