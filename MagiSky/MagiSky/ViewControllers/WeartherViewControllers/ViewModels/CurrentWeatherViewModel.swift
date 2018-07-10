//
//  CUrrentWeartherViewModel.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/6.
//  Copyright © 2018年 anran. All rights reserved.
//
/*
 首先，View不应了解任何Controller的细节，它只是一个用于展示内容的白板，给它什么，它就显示什么。
 无论是MVC，还是MVVM，这都是一定要遵循的原则；
 
 其次，Controller不应该了解任何Model的细节。
 在我的例子中，CurrentWeatherViewController用到的所有数据，
 都是通过CurrentWeatherViewModel提供的接口获取的。
 这是MVVM最有别于MVC的地方；
 
 第三，View Model拥有Model。
 在原来的MVC模式中，Model是被Controller拥有的，
 但是在MVVM中，Model被View Model持有。
 
 第四，Model不应该了解拥有它的View Model。
 在我的例子中，Location和WeatherData都对CurrentWeatherViewModel一无所知，
 这也是我们在实现MVVM中一定要遵循的原则。
 */
import Foundation
import UIKit

struct CurrentWeatherViewModel {
    // 自定义参数
    var isLocationReady = false
    var isWeatherReady = false
    
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    

    var location: Location! {
        didSet {
            if location != nil {
                self.isLocationReady = true
            }
            else {
                self.isLocationReady = false
            }
        }
    }
    
    var weather: WeatherData! {
        didSet {
            if weather != nil {
                self.isWeatherReady = true
            }
            else {
                self.isWeatherReady = false
            }
        }
    }

    var weatherIcon: UIImage {
        return UIImage.weatherIcon(
            of: weather.currently.icon) ?? UIImage()
    }
    
    var city: String {
        return location.name
    }
    
    var temperature: String {
        return String(
            format: "%.1f °C",
            weather.currently.temperature.toCelcius())
    }
    
    var humidity: String {
        return String(
            format: "%.1f %%",
            weather.currently.humidity * 100)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        
        return formatter.string(from: weather.currently.time)
    }
}
