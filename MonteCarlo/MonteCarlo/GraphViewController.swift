//
//  GraphBDDViewController.swift
//  MonteCarlo
//
//  Created by Loup Prévost on 19/12/2023.
//

import Foundation
import UIKit

class GraphViewController: UIViewController {
    
    private var fileBrain = FileBrain()
    private var graphBrain = GraphBrain()

    @IBOutlet weak var graphView: GraphView!
    
    // Bouton de reset de la BDD
    @IBAction func resetBDD(_ sender: UIButton) {
        fileBrain.reset(fileName: "BDDMonteCarlo.txt")
        drawGraph()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawGraph()
    }
    
    // Dessin du graph
    func drawGraph()
    {
        graphView.normalizePoints = graphBrain.normalizeBddMonteCarloData()
        graphView.setNeedsDisplay()
    }
    
    // S'il y a changement d'orientation, alors on redessine le graphique, sinon il y aurait des problème d'affichage dû
    // aux changement de proportions de l'UIView
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (_) in
            self.drawGraph()
        }, completion: nil)
    }
}
