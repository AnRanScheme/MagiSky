//
//  Extension+UIButton.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/12.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

extension UIButton {
    
    fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func setBackgroundColor(_ color: UIColor, forUIControlState state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color), for: state)
    }
    
    func setButtonDisabled() {
        self.isEnabled = false
        self.setBackgroundColor(UIColor.gray,
                                forUIControlState: .disabled)
        self.setTitleColor(UIColor.white,
                           for: .disabled)
    }
    
}
