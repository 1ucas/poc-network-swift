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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions

    @IBAction func iniciarTesteOperation(_ sender: UIButton) {
        startOperation = DispatchTime.now()
        //chamarOperation(selectedPage: 1)
    }
    
    @IBAction func iniciarTesteDireto(_ sender: Any) {
        startDireto = DispatchTime.now()
        //chamarDireto(selectedPage: 1)
    }
    
    @IBAction func iniciarTesteCompleto(_ sender: UIButton) {
        startOperation = DispatchTime.now()
        chamarOperation(selectedPage: 1)
        
        startDireto = DispatchTime.now()
        chamarDireto(selectedPage: 1)
    }
    
    // MARK: - Direto
    
    private func chamarDireto(selectedPage: Int) {
        ApiService().listBreweries(page: selectedPage) { _ in
            NSLog("ViewController Done - Direto \(selectedPage)")
            self.somaChamadasDireto += 1
            let novaPagina = selectedPage+1
            if(novaPagina == self.numChamadas + 1) {
                self.endDireto = DispatchTime.now()
                self.calcularValores()
            } else {
                self.chamarDireto(selectedPage: novaPagina)
            }
        }
    }
    
    private func calcularValores() {
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
    
    private func chamarOperation(selectedPage: Int) {
        ApiManager().listBreweries(page: selectedPage) { _ in
            NSLog("ViewController Done - Operation \(selectedPage)")
            self.somaChamadasOperation += 1
            let novaPagina = selectedPage+1
            if(novaPagina == self.numChamadas + 1) {
                self.endOperation = DispatchTime.now()
                self.calcularValoresOperation()
            } else {
                self.chamarOperation(selectedPage: novaPagina)
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
        }
    }
}

