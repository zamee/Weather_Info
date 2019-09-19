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
    let listOfCity = [ListOfCity]()
    
    @IBOutlet weak var cityListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityListTable.dataSource = self
        cityListTable.delegate = self
        
        cityListTable.rowHeight = UITableView.automaticDimension
        cityListTable.estimatedRowHeight = 120.0
        
        let cityListNib = UINib(nibName: "CityCell", bundle: Bundle.main)
        cityListTable.register(cityListNib, forCellReuseIdentifier: "CityCell")
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cityListTable.reloadData()
    }
    
    @IBAction func editBar(_ sender: UIBarButtonItem) {
        cityListTable.isEditing = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTapped))
    }
    
    @objc func doneButtonDidTapped(){
        cityListTable.isEditing = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBar(_:)))
    }
    
    public func alertWithTextField(title: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("") })
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        navigationController?.present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate{
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
                print("Failure \(value)")
            }
            if response.result.isSuccess,let value = response.result.value{
                do{
                    let weather = try JSONDecoder().decode(WeatherforeCast.self, from: value)
                    
                    cell.cityName.text = city.name
                    cell.cityTemparature.text = String(format: "%.0f",5/9 * (weather.currently.temperature-32))+("℃")
                    
                    switch(weather.currently.summary){
                    case "Humid And Overcast":
                        cell.cityWeatherImage.image = UIImage(named: "humid_and_overcast")
                        break
                    case "Light Rain And Humid":
                        cell.cityWeatherImage.image = UIImage(named: "light_Rain_and_humid")
                        break
                    case "Possible Drizzle and Humid":
                        cell.cityWeatherImage.image = UIImage(named: "possible_drizzle_and_humid")
                        break
                    case "Possible Light Rain and Humid":
                        cell.cityWeatherImage.image = UIImage(named: "possible_light_rain_and_humid")
                        break
                    case "Possible Light Rain":
                        cell.cityWeatherImage.image = UIImage(named: "possible_light_rain")
                        break
                    case "Rain And Humid":
                        cell.cityWeatherImage.image = UIImage(named: "rain_and_humid")
                        break
                    case "Humid And Foggy":
                        cell.cityWeatherImage.image = UIImage(named: "humid_and_foggy")
                        break
                    case "Humid":
                        cell.cityWeatherImage.image = UIImage(named: "humid")
                        break;
                    case "Humid and Overcast":
                        cell.cityWeatherImage.image = UIImage(named: "humid_and_overcast")
                        break
                    case "Partly Cloudy":
                        cell.cityWeatherImage.image = UIImage(named: "partly_cloudy")
                        break
                    case "Humid and Mostly Cloudy":
                        cell.cityWeatherImage.image = UIImage(named: "humid_and_mostly_cloudy")
                        break
                    case "Humid and Partly Cloudy":
                        cell.cityWeatherImage.image = UIImage(named: "humid_and_partly_cloudy")
                        break
                    case "Mostly Cloudy":
                        cell.cityWeatherImage.image = UIImage(named: "mostly_cloudy")
                        break
                    case "Overcast":
                        cell.cityWeatherImage.image = UIImage(named: "overcast")
                        break
                    case "Clear":
                        cell.cityWeatherImage.image = UIImage(named: "clear")
                        break
                    default:
                        cell.cityWeatherImage.image = UIImage(named: "default")
                        break
                    }
                    
                }catch{
                    print("ERROR \(error)")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allCity = cityStore.getAllCity()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let showDetailsCityWeather = storyboard.instantiateViewController(withIdentifier: "DetailsCityWeather") as? DetailsCityWeather{
            let city = allCity[indexPath.row]

            showDetailsCityWeather.cityDetails = city
            show(showDetailsCityWeather, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let allCity = self.cityStore.getAllCity()
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            try! self.cityStore.deleteCity(city: allCity[indexPath.row])
            self.cityListTable.reloadData()
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.alertWithTextField(title: "Edit City Name", placeholder: allCity[indexPath.row].name) { result in

                try! self.cityStore.updateCityNameByid(id: Int(allCity[indexPath.row].id), currentValue: String(allCity[indexPath.row].name), updatedValue: result)
                
                self.cityListTable.reloadData()
            }
        }
        share.backgroundColor = UIColor.gray
        
        return [delete, share]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

