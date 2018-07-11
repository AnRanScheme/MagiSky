//
//  SettingsTableViewCell.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/10.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingsTableViewCell"
    
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // 使用协议
    func configure(with vm: SettingsRepresentable) {
        label.text = vm.labelText
        accessoryType = vm.accessory
    }
}
