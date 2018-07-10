//
//  ViewController.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/4.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    var currentWeatherViewController: CurrentWeatherViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    
    private let segueCurrentWeather = "SegueCurrentWeather"
    private let segueWeekWeather = "SegueWeekWeather"
    private let segueSettings = "SegueSettings"
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        
        return manager
    }()
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchCity()
            fetchWeather()
        }
    }
    
    @IBAction func unwindToRootViewController(
        segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueCurrentWeather:
            guard let destination = segue.destination as? CurrentWeatherViewController else {
                fatalError("Invalid destination view controller!")
            }
            destination.delegate = self
            // 如果这里不对ViewModel进行赋值的话, ViewModel会一直为nil
            destination.viewModel = CurrentWeatherViewModel()
            currentWeatherViewController = destination
        case segueWeekWeather:
            guard let destination = segue.destination as? WeekWeatherViewController else {
                fatalError("Invalid destination view controller!")
            }
            weekWeatherViewController = destination
        case segueSettings:
            guard let navigationController =
                segue.destination as? UINavigationController else {
                    fatalError("Invalid destination view controller!")
            }
            
            guard let destination =
                navigationController.topViewController as?
                SettingsViewController else {
                    fatalError("Invalid destination view controller!")
            }
            
            destination.delegate = self
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActiveNotification()
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(
                RootViewController.applicationDidBecomeActive(notification:)),
            name: Notification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
    
    private func requestLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation)
        { (placemarks, error) in
            if let error = error {
                dump(error)
            } else if let city = placemarks?.first?.locality {
                self.currentWeatherViewController.viewModel?.location = Location(
                    name: city,
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude)
            }
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat,
                                                longitude: lon)
        { (response, error) in
            if let error = error {
                dump(error)
            }
            else if let response = response {
                self.currentWeatherViewController.viewModel?.weather = response
                self.weekWeatherViewController.viewModel =
                    WeekWeatherViewModel(weatherData: response.daily.data)
            }
        }
    }
    
    @objc func applicationDidBecomeActive(
        notification: Notification) {
        requestLocation()
    }
    
}

extension RootViewController: CLLocationManagerDelegate {
    
    /// 请求位置发生错误
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
    
    /// 权限发生改变
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }
    
}

extension RootViewController: CurrentWeatherViewControllerDelegate {
    
    func locationButtonPressed(controller: CurrentWeatherViewController) {
        print("Open locations.")
    }
    
    func settingsButtonPressed(controller: CurrentWeatherViewController) {
        print("Open Settings")
        performSegue(withIdentifier: segueSettings, sender: self)
    }
    
}

extension RootViewController: SettingsViewControllerDelegate {
    private func reloadUI() {
        currentWeatherViewController.updateView()
        weekWeatherViewController.updateView()
    }
    
    func controllerDidChangeTimeMode(
        controller: SettingsViewController) {
        reloadUI()
    }
    
    func controllerDidChangeTemperatureMode(
        controller: SettingsViewController) {
        reloadUI()
    }
}

