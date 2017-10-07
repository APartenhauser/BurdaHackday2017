//
//  RoundedCornerView.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit
// 
class RoundedCornerView: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = frame.width/2
    }
    
    func setColor(by state: DiagnosticsState) {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = state.color()
        }
    }
}
