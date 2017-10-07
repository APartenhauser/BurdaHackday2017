//
//  DiagnosticsViewController.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

class DiagnosticsViewController: UITableViewController {

    var currentDiagnostics: Array<Diagnostics> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Diagnostics"
        tableView.addTableViewCell(for: DiagnosticTableViewCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadedDiagnosticCount = 0
        currentDiagnostics = Diagnostics.allDiagnostics()
        for i in 0..<currentDiagnostics.count {
            perform(#selector(DiagnosticsViewController.loadedDiagnostic), with: nil, afterDelay: TimeInterval(i))
        }
    }
    
    var loadedDiagnosticCount = 0
    @objc func loadedDiagnostic() {
        let indexPath = IndexPath(row: loadedDiagnosticCount, section: 0)
        updateDiagnostic(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .none)
        loadedDiagnosticCount += 1
    }
    
    func updateDiagnostic(at index: IndexPath) {
        var diag = currentDiagnostics[index.row]
        diag.checked = true
        if let state = DiagnosticsState(rawValue: Int(arc4random()%3)) {
            diag.state = state
        }
        currentDiagnostics[index.row] = diag
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDiagnostics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiagnosticTableViewCell.Identifer, for: indexPath) as! DiagnosticTableViewCell
        
        cell.update(with: currentDiagnostics[indexPath.row])
        
        return cell
    }
}
