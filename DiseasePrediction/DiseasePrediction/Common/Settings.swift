//
//  Settings.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import Foundation

struct SettingKeys {
    static let firstStartKey = "SettingKeys.firstStartKey"
    static let loggedInKey = "SettingKeys.loggedInKey"
}

open class Settings: NSObject {
    open class var shared: Settings {
        struct Singleton {
            static let instance = Settings()
        }
        return Singleton.instance
    }
    
    let defaults = UserDefaults.standard
    
    open func save(_ value: Any, forKey key: String) {
        switch value {
        case is Int:
            defaults.set(value as! Int, forKey: key)
        case is Bool:
            defaults.set(value as! Bool, forKey: key)
        case is Float:
            defaults.set(value as! Float, forKey: key)
        default:
            defaults.set(value, forKey: key)
        }
    }
    
    open func load<T>(forKey key: String, defaultValue: T) -> T {
        guard let val = defaults.value(forKey: key) as? T else {
            return defaultValue
        }
        return val
    }
}
