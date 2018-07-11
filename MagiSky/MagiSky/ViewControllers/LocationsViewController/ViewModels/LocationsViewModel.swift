//
//  LocationsViewModel.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/11.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationsViewModel {
    let location: CLLocation?
    let locationText: String?
}

extension LocationsViewModel: LocationRepresentable {
    var labelText: String {
        if let locationText = locationText {
            return locationText
        }
        else if let location = location {
            return location.toString
        }
        
        return "Unknown position"
    }
}
