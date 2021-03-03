//
//  ViewController.swift
//  POCNetwork
//
//  Created by Lucas Ramos Maciel on 12/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var lblChamadas: UILabel!
    @IBOutlet weak var lblTempoMedio: UILabel!
    @IBOutlet weak var lblTempoTotal: UILabel!
    
    @IBOutlet weak var lblChamadasOperation: UILabel!
    @IBOutlet weak var lblTempoMedioOperation: UILabel!
    @IBOutlet weak var lblTempoTotalOperation: UILabel!
    
    @IBOutlet weak var lblDiferencaTempo: UILabel!
    
    
    // MARK: - Propriedades

    let numChamadas = 10

    var startDireto = DispatchTime.now()
    var startOperation = DispatchTime.now()
    
    var endDireto = DispatchTime.now()
    var endOperation = DispatchTime.now()
    
    var somaChamadasDireto = 0
    var somaTempoTotalDireto = 0.0
    
    var somaChamadasOperation = 0
    var somaTempoTotalOperation = 0.0

    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions

    @IBAction func iniciarTesteOperation(_ sender: UIButton) {
        chamarOperation(selectedPageOperation: 1)
    }
    
    @IBAction func iniciarTesteDireto(_ sender: Any) {
        chamarDireto(selectedPageDireto: 1)
    }
    
    @IBAction func iniciarTesteCompleto(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.chamarOperation(selectedPageOperation: 1)
        }
        DispatchQueue.main.async {
            self.chamarDireto(selectedPageDireto: 1)
        }
    }
    
    // MARK: - Direto
    
    private func chamarDireto(selectedPageDireto: Int) {
        self.startDireto = DispatchTime.now()
        ApiService().listBreweries(page: selectedPageDireto) { _ in
            self.endDireto = DispatchTime.now()
            NSLog("ViewController Done - Direto \(selectedPageDireto)")
            self.somaChamadasDireto += 1
            self.calcularValoresDireto()
            if(selectedPageDireto < self.numChamadas) {
                let novaPagina = selectedPageDireto + 1
                self.chamarDireto(selectedPageDireto: novaPagina)
            }
        }
    }
    
    private func calcularValoresDireto() {
        let nanoTime = endDireto.uptimeNanoseconds - startDireto.uptimeNanoseconds
        let tempoTotal = (Double(nanoTime) / 1_000_000_000)
        
        self.somaTempoTotalDireto += tempoTotal
        
        let tempoMedio = self.somaTempoTotalDireto / Double(self.somaChamadasDireto)
        
        DispatchQueue.main.async {
            self.lblChamadas.text = "\(self.somaChamadasDireto)"
            self.lblTempoMedio.text = String(format: "%.3f ms", tempoMedio)
            self.lblTempoTotal.text = String(format: "%.3f s", self.somaTempoTotalDireto)
        }
    }
    
    
    // MARK: - Operation
    
    private func chamarOperation(selectedPageOperation: Int) {
        self.startOperation = DispatchTime.now()
        ApiManager().listBreweries(page: selectedPageOperation) { _ in
            self.endOperation = DispatchTime.now()
            NSLog("ViewController Done - Operation \(selectedPageOperation)")
            self.somaChamadasOperation += 1
            self.calcularValoresOperation()
            if(selectedPageOperation < self.numChamadas) {
                let novaPagina = selectedPageOperation + 1
                self.chamarOperation(selectedPageOperation: novaPagina)
            }
        }
    }
    
    private func calcularValoresOperation() {
        let nanoTime = endOperation.uptimeNanoseconds - startOperation.uptimeNanoseconds
        let tempoTotal = (Double(nanoTime) / 1_000_000_000)
        
        somaTempoTotalOperation += tempoTotal
        
        let tempoMedio = self.somaTempoTotalOperation / Double(self.somaChamadasOperation)

        DispatchQueue.main.async {
            self.lblChamadasOperation.text = "\(self.somaChamadasOperation)"
            self.lblTempoMedioOperation.text = String(format: "%.3f ms", tempoMedio)
            self.lblTempoTotalOperation.text = String(format: "%.3f s", self.somaTempoTotalOperation)
            
            if(self.somaTempoTotalDireto != 0.0) {
                let tempoMedioDireto = self.somaTempoTotalDireto / Double(self.somaChamadasDireto)
                let diferencaTempoMedio = tempoMedio - tempoMedioDireto
                let sinal = diferencaTempoMedio > 0 ? "+" : ""
                self.lblDiferencaTempo.text = String(format: "%@%.3f ms", sinal, diferencaTempoMedio)
                self.lblDiferencaTempo.textColor = diferencaTempoMedio > 0 ? .red : .green
            }
        }
    }
}

