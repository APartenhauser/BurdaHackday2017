//
//  DemographicAddition.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

// Store: Sports type, smoking, ...
class DemographicAddition: NSObject {
    enum SportsType: String {
        case verySporty = "Athlete Guy"
        case normal = "Normal Guy"
        case unSporty = "Unsporty Guy"
    }

    var mySportsType: SportsType = .normal
    var smoker: Bool = false
    
    var activeSportsman: Bool {
        return mySportsType == .normal || mySportsType == .verySporty
    }
}
