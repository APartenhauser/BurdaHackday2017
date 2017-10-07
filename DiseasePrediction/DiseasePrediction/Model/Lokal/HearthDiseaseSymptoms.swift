//
//  HearthDiseaseSymptoms.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

struct Symptom {
    var name: String
    var value: Bool
}

class HearthDiseaseSymptoms: NSObject {
    var list: Array<Symptom> = []
    
    override init() {
        super.init()
        
        list += [Symptom(name: "Dizziness", value: false)]
        list += [Symptom(name: "Breathing Problems", value: false)]
        list += [Symptom(name: "Anorexia", value: false)] // Appetitlosigkeit
        list += [Symptom(name: "Sickness", value: false)] // Übelkeit
    }
}
