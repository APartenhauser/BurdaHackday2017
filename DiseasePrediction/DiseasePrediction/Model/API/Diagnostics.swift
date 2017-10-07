//
//  Diagnostics.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

enum DiagnosticsState: Int {
    case fine, warning, critical, notChecked
    
    func color() -> UIColor {
        switch self {
        case .fine:
            return .green
        case .warning:
            return .yellow
        case .critical:
            return .red
        case .notChecked:
            return .clear
        }
    }
    
    func shouldShowInfo() -> Bool {
        return self == .warning || self == .critical
    }
}

struct Diagnostics {
    static func allDiagnostics() -> Array<Diagnostics> {
        return [Diagnostics(diseaseName: "Blood preasure", checked: false, state: .notChecked),
        Diagnostics(diseaseName: "Pulse at rest", checked: false, state: .notChecked),
        Diagnostics(diseaseName: "Heart attack risk", checked: false, state: .notChecked),
        Diagnostics(diseaseName: "Diabetes", checked: false, state: .notChecked),
        Diagnostics(diseaseName: "Thrombose", checked: false, state: .notChecked),
        Diagnostics(diseaseName: "Brain attack", checked: false, state: .notChecked)]
    }
    
    var diseaseName: String
    var checked: Bool
    var state: DiagnosticsState
}
