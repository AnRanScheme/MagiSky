//
//  SettingContent.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/10.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

protocol SettingsRepresentable {
    var labelText: String { get }
    var accessory: UITableViewCell.AccessoryType { get }
}
