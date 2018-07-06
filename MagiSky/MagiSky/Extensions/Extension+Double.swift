//
//  Extension+Double.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation

extension Double {
    func toCelcius() -> Double {
        return (self - 32.0) / 1.8
    }
}
