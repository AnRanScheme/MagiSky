//
//  WeekWeatherViewController.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/10.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeartherViewController {
    
    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    var viewModel: WeekWeatherViewModel? {
        didSet {
            DispatchQueue.main.async { self.updateView() }
        }
    }
    
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if let _ = viewModel {
            updateWeatherDataContainer()
            
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "Load Location/Weather failed!"
        }
    }
    
    func updateWeatherDataContainer() {
        weatherContainerView.isHidden = false
        weekWeatherTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension WeekWeatherViewController: UITableViewDataSource {
    
    func numberOfSections(
        in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSections
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfDays
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(
                withIdentifier: WeekWeatherTableViewCell.reuseIdentifier,
                for: indexPath) as? WeekWeatherTableViewCell else {
                    fatalError("Unexpected table view cell")
        }
        /* 面向协议编程
        通常来讲就设计模式来讲 cell和view你应该持有ViewModel 和 model
         我们可以通过面向协议编程使用protocol 来提供接口实现
         */
        if let vm = viewModel?.viewModel(for: indexPath.row) {
            cell.configure(with: vm)
        }
        
        return cell
    }
    
}
