//
//  AddNewCity.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 11/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import UIKit
import Alamofire

class AddNewCity: UIViewController {
    
    var searchController: UISearchController!

    @IBOutlet weak var searchCityBar: UISearchBar!
    @IBOutlet weak var searchResultCityTable: UITableView!
    
    var cityNameFromAPi: [String] = []
    var cityLat:[String] = []
    var cityLng :[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultCityTable.delegate = self
        searchResultCityTable.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchCityBar.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        
    }
    
    func filterData(val: String) {
        
        if val.count>3{
            getCitiesInformation(searchCityByKey: val)
        }
        searchResultCityTable.reloadData()
    }
    
    func restore() {
        cityNameFromAPi.removeAll()
        searchResultCityTable.reloadData()
    }
    

    func getCitiesInformation(searchCityByKey : String) {

        Alamofire.request("https://api.apixu.com/v1/search.json?key=c500ea3d1fd7408dacb81311190909&q=\(searchCityByKey)",method: .get).responseData{
            response in
            if response.result.isFailure,let value = response.result.error{
                print(value)
            }
            if response.result.isSuccess,let value = response.result.value{
                do{
                    let listOfCities = try JSONDecoder().decode(ListOfCities.self, from: value)
                    for n in 0..<listOfCities.count{
                        //print(listOfCities[n].name)
                        self.cityNameFromAPi.append(listOfCities[n].name)
                        self.cityLat.append(String(listOfCities[n].lat))
                        self.cityLat.append(String(listOfCities[n].lon))
                    }
                }catch{
                    print(value)
                }
            }
        }
    }
    
    @IBAction func cancelSearch(_ sender: UIButton) {
    }

}

extension AddNewCity: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchtext = searchController.searchBar.text{
            filterData(val: searchtext)
        }
    }
}

extension AddNewCity: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchtext = searchBar.text{
            filterData(val: searchtext)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchtext = searchBar.text, !searchtext.isEmpty{
            restore()
        }
    }
}

extension AddNewCity : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNameFromAPi.count
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultCityTable.dequeueReusableCell(withIdentifier: "CityName", for: indexPath)
        print(cityNameFromAPi[indexPath.row])
        cell.textLabel?.text = cityNameFromAPi[indexPath.row]
        return cell
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Add", message: "Do you want to add \(cityNameFromAPi[indexPath.row])", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController,animated: true,completion: nil)
        
        searchController.isActive = false
        
    }
}
