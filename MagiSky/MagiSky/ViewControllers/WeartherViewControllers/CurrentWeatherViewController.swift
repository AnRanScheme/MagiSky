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
    
    /// weak修饰避免循环引用 当然只有类专属协议才可以被weak 修饰
    weak var delegate: CurrentWeatherViewControllerDelegate?
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.locationButtonPressed(controller: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        delegate?.settingsButtonPressed(controller: self)
    }
    
    var now: WeatherData? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    var location: Location? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let now = now, let location = location {
            updateWeatherContainer(with: now, at: location)
        }
        else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text =
            "Cannot load fetch weather/location data from the network."
        }
    }
    
    func updateWeatherContainer(
        with data: WeatherData, at location: Location) {
        weatherContainerView.isHidden = false
        
        // 1. 设置地点
        locationLabel.text = location.name
        
        // 2. 转换为摄氏度
        temperatureLabel.text = String(
            format: "%.1f °C",
            data.currently.temperature.toCelcius())
        
        // 3. 设置天气图片
        weatherIcon.image = weatherIcon(
            of: data.currently.icon)
        
        // 4. 湿度格式设置
        humidityLabel.text = String(
            format: "%.1f",
            data.currently.humidity)
        
        // 5. 天气
        summaryLabel.text = data.currently.summary
        
        // 6. 日期
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        dateLabel.text = formatter.string(
            from: data.currently.time)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
