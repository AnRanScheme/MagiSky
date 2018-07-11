//
//  LocationTableViewCell.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/11.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LocationCell"
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with viewModel: LocationRepresentable) {
        label.text = viewModel.labelText
    }
    
}
