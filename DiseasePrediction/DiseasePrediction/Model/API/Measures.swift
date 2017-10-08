//
//  Measures.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

class Measures: NSObject {
    static func allMeasures() -> Array<Measure> {
        return [Measure(name: "Weight", value: "90", unit: "kg"),
                Measure(name: "Height", value: "190", unit: "cm"),
                Measure(name: "Fat Free Mass", value: "75", unit: "kg"),
                Measure(name: "Fat Ratio", value: "17", unit: "%"),
                Measure(name: "Fat Mass Weight", value: "15", unit: "kg"),
                Measure(name: "Diastolic Blood Pressure", value: "110 / 75", unit: "mm Hg"),
                Measure(name: "Systolic Blood Pressure", value: "110 / 80", unit: "mm Hg"),
                Measure(name: "Avg. Rest Heart Pulse", value: "60", unit: "bpm"),
                Measure(name: "SP02", value: "98", unit: "%"),
                Measure(name: "Body Temperature", value: "36.6", unit: "°C")]
    }
}

final class Measure: NSObject, ResponseConvertible, ResponseCollectionConvertible, URLStringConvertible {
    var name: String = ""
    var value: String = ""
    var unit: String = ""
    
    var fullValue: String {
        return value + " " + unit
    }
    
    static var urlRoute: String {
        return ""
    }
    
    static func collection(_ responseData: Array<Dictionary<String, Any>>) -> [Measure] {
        var myMeasures: Array<Measure> = []
        for singleMeasure in responseData {
            myMeasures += [Measure(responseData: singleMeasure)]
        }
        
        return myMeasures
    }
    
    convenience init(name: String, value: String, unit: String) {
        self.init(responseData: [:])
        self.name = name
        self.value = value
        self.unit = unit
    }
    
    required init(responseData: Dictionary<String, Any>) {
        super.init()
        name = responseData["name"] as? String ?? ""
        value = responseData["value"] as? String ?? ""
        unit = responseData["unit"] as? String ?? ""
    }
}
