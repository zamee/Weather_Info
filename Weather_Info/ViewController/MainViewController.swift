//
//  ViewController.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 7/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class MainViewController: UIViewController {
    
    var realm = try! Realm()
    let cityStore = CityStore()
    
    @IBOutlet weak var cityListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityListTable.dataSource = self
        
        cityListTable.rowHeight = UITableView.automaticDimension
        cityListTable.estimatedRowHeight = 54.0
        
        let cityListNib = UINib(nibName: "CityCell", bundle: Bundle.main)
        cityListTable.register(cityListNib, forCellReuseIdentifier: "CityCell")
    }
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityStore.getAllCity().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allCity = cityStore.getAllCity()
        let cell = cityListTable.dequeueReusableCell(withIdentifier: "CityCell") as! CityCell
        let city = allCity[indexPath.row]
        
        Alamofire.request("https://api.darksky.net/forecast/b46e33968e621170ca0b7be45867b126/\(city.lat),\(city.lng)",method: .get).responseData{
            response in
            if response.result.isFailure,let value = response.result.error{
                print(value)
            }
            if response.result.isSuccess,let value = response.result.value{
                do{
                    let weather = try JSONDecoder().decode(WeatherforeCast.self, from: value)
                    cell.cityName.text = city.name
                    cell.cityTemparature.text = String(format: "%.1f",5/9 * (weather.currently.temperature-32))+("℃")
                    cell.cityWeatherImage.image = UIImage(named: "cloudy")
                }catch{
                    print(error)
                }
            }
        }
        return cell
    }
    
}

