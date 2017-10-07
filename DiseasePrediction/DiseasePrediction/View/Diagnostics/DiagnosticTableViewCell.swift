//
//  DiagnosticTableViewCell.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

protocol DiagnosticTableViewCellDelegate: class {
    func shouldShowInfo(_ cell: DiagnosticTableViewCell)
}

class DiagnosticTableViewCell: UITableViewCell, AddableNib {
    @IBOutlet weak var diseaseInfoButton: UIButton!
    @IBOutlet weak var statusView: RoundedCornerView!
    @IBOutlet weak var diseaseLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var delegate: DiagnosticTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(with diagnostic: Diagnostics) {
        statusView.setColor(by: diagnostic.state)
        diseaseLabel.text = diagnostic.diseaseName
        diseaseInfoButton.alpha = diagnostic.state.shouldShowInfo() ? 1 : 0
        if diagnostic.checked {
            checkboxButton.setImage(UIImage(named: "checkboxOn"), for: .normal)
            loadingIndicator.stopAnimating()
            loadingIndicator.alpha = 0
        } else {
            loadingIndicator.startAnimating()
            loadingIndicator.alpha = 1
            checkboxButton.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func infoPressed(_ sender: Any) {
        delegate?.shouldShowInfo(self)
    }
    
}
