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
    
    var AllCity = [ListOfCity]()
    
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
        self.AllCity.removeAll()
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
                    self.AllCity.removeAll()
                    self.AllCity = listOfCities
                }catch{
                    print(value)
                }
            }
        }
    }
    
    func saveCityInfo(name: String, lat: Double, lon: Double) {
        let saveCity = CityStore()
        print(name)
        let insertNewCity = saveCity.makeNewCity(city: name,lat: lat,lng: lon)
        if saveCity.saveNewCity(city: insertNewCity){
            print("worked")
        }
        //searchController.isActive = false
        self.restore()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelSearch(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        return self.AllCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultCityTable.dequeueReusableCell(withIdentifier: "CityName", for: indexPath)
        guard self.AllCity.count>0 else {
            return cell
        }
        cell.textLabel?.text = self.AllCity[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let alertController = UIAlertController(title: "Add", message: "Do you want to add \(self.AllCity[indexPath.row].name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.saveCityInfo(
                name: self.AllCity[indexPath.row].name,
                lat: Double(self.AllCity[indexPath.row].lat),
                lon: Double(self.AllCity[indexPath.row].lon))
        })
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
        searchController.isActive = false
    }
}
