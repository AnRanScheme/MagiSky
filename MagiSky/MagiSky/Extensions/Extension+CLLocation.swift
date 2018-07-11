//
//  Extension+CALcation.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/11.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    var toString: String {
        let latitude = String(format: "%.3f", coordinate.latitude)
        let longitude = String(format: "%.3f", coordinate.longitude)
        
        return "\(latitude), \(longitude)"
    }
}
