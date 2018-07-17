//
//  CurrentWeartherViewController.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/6.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

/// 类专属协议只能由类继承
protocol CurrentWeatherViewControllerDelegate: class {
    func locationButtonPressed(
        controller: CurrentWeatherViewController)
    func settingsButtonPressed(
        controller: CurrentWeatherViewController)
}

class CurrentWeatherViewController: WeartherViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    /// weak修饰避免循环引用 当然只有类专属协议才可以被weak 修饰
    weak var delegate: CurrentWeatherViewControllerDelegate?
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        delegate?.settingsButtonPressed(controller: self)
    }
    
    var viewModel: CurrentWeatherViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let vm = viewModel, vm.isUpdateReady {
            updateWeatherContainer(with: vm)
        }
        else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text =
            "Load weather/location failed."
        }
    }
    
    func updateWeatherContainer(
        with vm: CurrentWeatherViewModel) {
        weatherContainerView.isHidden = false
        // 1. 设置地点
        locationLabel.text = vm.city
        // 2. 转换为摄氏度
        temperatureLabel.text = vm.temperature
        // 3. 设置天气图片
        weatherIcon.image = vm.weatherIcon
        // 4. 湿度格式设置
        humidityLabel.text = vm.humidity
        // 5. 天气
        summaryLabel.text = vm.summary
        // 6. 日期
        dateLabel.text = vm.date
    }

}
