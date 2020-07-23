//
//  DiffableTableViewVC.swift
//  Diffable DataSources
//
//  Created by Meet Soni on 28/02/20.
//  Copyright © 2020 Meet Soni. All rights reserved.
//

import UIKit

fileprivate typealias UserDataSource = UITableViewDiffableDataSource<DiffableTableViewVC.Section, Country>
fileprivate typealias UsersSnapshot = NSDiffableDataSourceSnapshot<DiffableTableViewVC.Section, Country>

class DiffableTableViewVC: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let alertService = AlertService()
    private var dataSource: UserDataSource!
    
    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureNavigationItem()
        
        searchBar.searchBarStyle = .minimal
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        let countryNames = ["Afghanistan",
                            "Albania",
                            "Algeria",
                            "Andorra",
                            "Angola",
                            "Antigua and Barbuda",
                            "Argentina",
                            "Armenia",
                            "Australia",
                            "Austria",
                            "Azerbaijan",
                            "Bahamas",
                            "Bahrain",
                            "Bangladesh",
                            "Barbados",
                            "Belarus"]
        for name in countryNames {
            countries.append(Country(name: name))
        }
        
        configureDataSource()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        performSearch(searchQuery: nil)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource
            <Section, Country>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath,
                country: Country) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = country.name
                cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    func performSearch(searchQuery: String?) {
        let filteredCountries: [Country]
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            filteredCountries = countries.filter { $0.contains(query: searchQuery) }
        } else {
            filteredCountries = countries
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCountries, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @IBAction private func didTapAddButton() {
        let alert = alertService.createUserAlert { name in
            self.addNewUser(with: name)
            print(name)
        }
        present(alert, animated: true)
    }
    
    private func addNewUser(with name: String) {
        let user = Country(name: name)
        countries.append(user)
        
        createSnapshot(from: countries)
        
    }
    
    private func createSnapshot(from users: [Country]) {
        var snapshot = UsersSnapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(countries)
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    func configureNavigationItem() {
        let editingItem = UIBarButtonItem(title: tableView.isEditing ? "Done" : "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.rightBarButtonItems = [editingItem]
    }
    
    @objc
    func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        configureNavigationItem()
    }
}

extension DiffableTableViewVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchQuery: searchText)
    }
}

extension DiffableTableViewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = dataSource.itemIdentifier(for: indexPath) {
            print("Selected country \(country.name)")
        }
    }
}
