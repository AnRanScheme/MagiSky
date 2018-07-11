//
//  SettingsViewController.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/10.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func controllerDidChangeTimeMode(
        controller: SettingsViewController)
    func controllerDidChangeTemperatureMode(
        controller: SettingsViewController)
}

class SettingsViewController: UITableViewController {
    /// ...
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingsViewController {
    // MARK: - Table view data source
    
    private enum Section: Int {
        case date
        case temperature
        
        var numberOfRows: Int {
            return 2
        }
        
        static var count: Int {
            return Section.temperature.rawValue + 1
        }
    }
    
    override func numberOfSections(
        in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected section index")
        }
        
        return section.numberOfRows
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Date format"
        }
        
        return "Temperature unit"
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier,
            for: indexPath) as? SettingsTableViewCell else {
                fatalError("Unexpected talbe view cell")
        }
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        
        var vm: SettingsRepresentable?
        
        switch section {
        case .date:
            guard let dateMode = DateMode(rawValue: indexPath.row) else {
                fatalError("Invalide IndexPath")
            }
            vm = SettingsDateViewModel(dateMode: dateMode) 
        case .temperature:
            guard let temperatureMode = TemperatureMode(
                rawValue: indexPath.row) else {
                    fatalError("Invalid IndexPath")
            }
            vm = SettingsTemperatureViewModel(
                temperatureMode: temperatureMode)
        }
        /*
         实际上，这就是protocol在这种就用法里发挥的重要作用。
         如果，我们在SettingsTableViewCell中直接访问了SettingsDateViewModel
         或者SettingsTemperatureViewModel，显然我们就犯规了。
         但我们使用的是SettingRepresentable，其实，它只约束了一些接口。
         对于我们具体用哪些View Model实际提供了数据，
         View仍旧是一无所知的，因此也并没有打破MVVM设定的原则，
         并且通过这种做法，我们进一步从View Controller中抽离了一些UI相关的细节，
         让它只承担了连接的作用。而这，就是所谓面向protocol编程优雅和简洁的地方。
         */
        // 协议
        if let vm = vm {
            cell.configure(with: vm)
        }
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(
            rawValue: indexPath.section) else {
                fatalError("Unexpected section index")
        }
        
        switch section {
        case .date:
            let dateMode = UserDefaults.dateMode()
            guard indexPath.row != dateMode.rawValue else { return }
            
            if let newMode = DateMode(rawValue: indexPath.row) {
                UserDefaults.setDateMode(to: newMode)
            }
            
            delegate?.controllerDidChangeTimeMode(controller: self)
            
        case .temperature:
            let temperatureMode = UserDefaults.temperatureMode()
            guard indexPath.row != temperatureMode.rawValue else { return }
            
            if let newMode = TemperatureMode(rawValue: indexPath.row) {
                UserDefaults.setTemperatureMode(to: newMode)
            }
            
            delegate?.controllerDidChangeTemperatureMode(controller: self)
        }
        
        let sections = IndexSet(integer: indexPath.section)
        tableView.reloadSections(sections, with: .none)
    }
}


