//
//  SingleMeasureTableViewCell.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

class SingleMeasureTableViewCell: UITableViewCell, AddableNib {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    func update(with measure: Measure) {
        nameLabel.text = measure.name
        valueLabel.text = measure.fullValue
    }
}
