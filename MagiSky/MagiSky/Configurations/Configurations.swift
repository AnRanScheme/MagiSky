//
//  Configurations.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/5.
//  Copyright © 2018年 anran. All rights reserved.
//

import Foundation

struct API {
    static let key: String = "72178b5afa37a4d11a35fec83f06012d"
    static let baseUrl: URL = URL(string: "https://api.darksky.net/forecast")!
    static let authenticatedUrl = baseUrl.appendingPathComponent(key)
}
