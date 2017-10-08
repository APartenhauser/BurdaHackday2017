//
//  Bundle+Util.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

extension Bundle {
    static func url(for path: String, extensionName: String = "html") -> URL? {
        let bundle = Bundle.main
        if let filePath = bundle.path(forResource: path, ofType: extensionName) {
            return URL(fileURLWithPath: filePath)
        }
        return nil
    }
}
