//
//  HealthProfile.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

// Store: name, surename, birthday, heartrate, bloodpreasure,
class HealthProfile: NSObject {
    enum Gender: String {
        case male
        case female
        case unspecified
    }
    
    var name: String = "Andreas"
    var sureName: String = "Partenhauser"
    var age: Int = 33
    var gender: Gender = .unspecified
    
    var hearthDiseaseSymptoms = HearthDiseaseSymptoms()
    var demographicAdditions = DemographicAddition()
}
