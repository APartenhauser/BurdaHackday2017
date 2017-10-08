//
//  ProfileTableViewCell.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell, AddableNib {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with profile: HealthProfile) {
        nameLabel.text = profile.fullName
        ageLabel.text = "\(profile.age) Jahre"
        genderLabel.text = profile.gender.rawValue
    }
}
