//
//  ProfileManager.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

class ProfileManager: NSObject {
    var healthProfile = HealthProfile()
    
    open class var shared: ProfileManager {
        struct Singleton {
            static let instance = ProfileManager()
        }
        return Singleton.instance
    }
}
