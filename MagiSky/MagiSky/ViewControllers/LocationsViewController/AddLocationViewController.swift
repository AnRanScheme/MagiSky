//
//  AddLocationViewController.swift
//  MagiSky
//
//  Created by 安然 on 2018/7/11.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddLocationViewControllerDelegate {
    func controller(
        _ controller: AddLocationViewController,
        didAddLocation location: Location)
}

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!

    var viewModel: AddLocationViewModel!
    
    var delegate: AddLocationViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a location"
        viewModel = AddLocationViewModel()
        
        viewModel.locationsDidChange = {
            [unowned self] locations in
            self.tableView.reloadData()
        }
        
        viewModel.queryingStatusDidChange = {
            [unowned self] isQuerying in
            if isQuerying {
                self.title = "Searching..."
            }
            else {
                self.title = "Add a location"
            }
        }
    }
}

extension AddLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLocations
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationTableViewCell.reuseIdentifier,
            for: indexPath) as? LocationTableViewCell else {
                fatalError("Unexpected table view cell")
        }
        
        if let vm = viewModel.locationViewModel(at: indexPath.row) {
            cell.configure(with: vm)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let location =
            viewModel.location(at: indexPath.row) else { return }
        
        delegate?.controller(self, didAddLocation: location)
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
         viewModel.queryText = searchBar.text ?? ""
    }
    
    func searchBarCancelButtonClicked(
        _ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.queryText = searchBar.text ?? ""
    }
}
