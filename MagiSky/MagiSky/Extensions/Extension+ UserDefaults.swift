//
//  Extension+ UserDefaults.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/10.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation

enum DateMode: Int {
    case text
    case digit
    
    var format: String {
        return self == .text ? "E, dd MMMM" : "EEEEE, MM/dd"
    }
}

enum TemperatureMode: Int {
    case celsius
    case fahrenheit
}

struct UserDefaultsKeys {
    static let dateMode = "dateMode"
    static let temperatureMode = "temperatureMode"
}

extension UserDefaults {
    static func dateMode() -> DateMode {
        let value = UserDefaults.standard.integer(
            forKey: UserDefaultsKeys.dateMode)
        
        return DateMode(rawValue: value) ?? DateMode.text
    }
    
    static func setDateMode(to value: DateMode) {
        UserDefaults.standard.set(
            value.rawValue,
            forKey: UserDefaultsKeys.dateMode)
    }
    
    static func temperatureMode() -> TemperatureMode {
        let value = UserDefaults.standard.integer(
            forKey: UserDefaultsKeys.temperatureMode)
        
        return TemperatureMode(rawValue: value) ??
            TemperatureMode.celsius
    }
    
    static func setTemperatureMode(to value: TemperatureMode) {
        UserDefaults.standard.set(
            value.rawValue,
            forKey: UserDefaultsKeys.temperatureMode)
    }
}
