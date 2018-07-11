//
//  WeekWeatherViewModel.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/10.
//  Copyright © 2018年 anran. All rights reserved.
//
/*
 在MVVM模式里，Controller不应该直接与Model进行任何交互。
 因此，WeekWeatherViewModel还应该为Controller
 提供UITableViewDataSource需要的数据
 */
import UIKit
import Foundation

struct WeekWeatherViewModel {
    
    let weatherData: [ForecastData]
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherData.count
    }
    
    func viewModel(for index: Int)
        -> WeekWeatherDayViewModel {
            return WeekWeatherDayViewModel(
                weatherData: weatherData[index])
    }
    
}
