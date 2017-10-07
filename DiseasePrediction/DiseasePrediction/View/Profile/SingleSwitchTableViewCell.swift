//
//  SingleSwitchTableViewCell.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

protocol SingleSwitchTableViewCellDelegate: class {
    func didSelect(_ cell: SingleSwitchTableViewCell, state: Bool)
}

class SingleSwitchTableViewCell: UITableViewCell, AddableNib {
    
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var singleSwitch: UISwitch!
    
    weak var delegate: SingleSwitchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func toggledSwitch(_ sender: UISwitch) {
        delegate?.didSelect(self, state: sender.isOn)
    }
    
}
