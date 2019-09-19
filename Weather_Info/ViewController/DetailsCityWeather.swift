//
//  DetailsCityWeatherViewController.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 7/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import UIKit
import Alamofire

class DetailsCityWeather: UIViewController, UICollectionViewDataSource{
    @IBOutlet weak var weeklyTemparature: UITableView!
    
    @IBOutlet weak var SunRiseLabel: UILabel!
    @IBOutlet weak var SunSetLabel: UILabel!
    @IBOutlet weak var current_temp: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var hourlyShowTemparature: UICollectionView!
    
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    
    @IBOutlet weak var cloud1LeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cloud2LeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var cloud3LeftConstraint: NSLayoutConstraint!
    
    
    
    var cityDetails = City()
    var weatherForeCast: WeatherforeCast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourlyShowTemparature.dataSource = self
        weeklyTemparature.dataSource = self
        weeklyTemparature.delegate = self
        
        currentCityName.text = cityDetails.name
        getCurrentCityWeatherInformation(lat: cityDetails.lat, lng: cityDetails.lng)
        
        let HourlyListNib = UINib(nibName: "UICollectionViewForHourlyTemparature", bundle: Bundle.main)
        hourlyShowTemparature.register(HourlyListNib, forCellWithReuseIdentifier: "UICollectionViewForHourlyTemparature")
        
        let weeklyListNib = UINib(nibName: "DailyTemparatureCellTableViewCell", bundle: Bundle.main)
        weeklyTemparature.register(weeklyListNib, forCellReuseIdentifier: "DailyTemparatureCellTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cloud1LeftConstraint.constant -= view.frame.width
        cloud2LeftConstraint.constant -= view.frame.width
        cloud3LeftConstraint.constant -= view.frame.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 15, delay: 5, options: [.repeat,.curveLinear], animations: {
            self.cloud1LeftConstraint.constant = self.view.bounds.width * 1
            self.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 15, delay: 5, options: [.repeat,.curveLinear], animations: {
            self.cloud2LeftConstraint.constant = self.view.bounds.width * 1
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 20, delay: 5, options: [.repeat,.curveLinear], animations: {
            self.cloud3LeftConstraint.constant = self.view.bounds.width * 1
            self.view.layoutIfNeeded()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherForeCast?.hourly.data.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewForHourlyTemparature", for: indexPath) as!
        UICollectionViewForHourlyTemparature
        roundCell(cell: cell)
        if let weather = weatherForeCast?.hourly.data[indexPath.row] {
            cell.collectionCellTime.text = getDate(unixdate: weather.time)
            cell.collectionCellTemp.text = String(format: "%.0f",5/9 * (weather.temperature-32))+("℃")
            setCellImage(cell: cell, indexPath: indexPath)
        }

        return cell
    }

    func getCurrentCityWeatherInformation(lat: Double, lng: Double){
        Alamofire.request("https://api.darksky.net/forecast/b46e33968e621170ca0b7be45867b126/\(lat),\(lng)",method: .get).responseData{
            response in
            if response.result.isFailure,let value = response.result.error{
                print(value)
            }
            if response.result.isSuccess,let value = response.result.value{
                do{
                    let weather = try JSONDecoder().decode(WeatherforeCast.self, from: value)
                    self.weatherForeCast = weather
                    self.hourlyShowTemparature.reloadData()
                    self.weeklyTemparature.reloadData()
                    self.SunRiseLabel.text = "↑"+self.getDate(unixdate: Int(weather.daily.data[0].sunriseTime))
                    self.SunSetLabel.text = "↓"+self.getDate(unixdate: Int(weather.daily.data[0].sunsetTime))
                    self.current_temp.text = String(format: "%.0f",5/9 * (weather.currently.temperature-32))+("℃")
                    self.currentDescription.text = weather.daily.data[0].summary
                }catch{
                    print(value)
                }
            }
        }
    }
    
    private func roundCell(cell: UICollectionViewForHourlyTemparature){
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
    
    private func setCellImage(cell: UICollectionViewForHourlyTemparature, indexPath: IndexPath){
        let weather = weatherForeCast?.hourly.data[indexPath.row]
        print(weather?.summary ?? "nil")
        switch(weather?.summary){
        case "Humid And Overcast":
            cell.collectionCellImage.image = UIImage(named: "humid_and_overcast")
            break
        case "Light Rain And Humid":
            cell.collectionCellImage.image = UIImage(named: "light_Rain_and_humid")
            break
        case "Possible Drizzle and Humid":
            cell.collectionCellImage.image = UIImage(named: "possible_drizzle_and_humid")
            break
        case "Possible Light Rain and Humid":
            cell.collectionCellImage.image = UIImage(named: "possible_light_rain_and_humid")
            break
        case "Possible Light Rain":
            cell.collectionCellImage.image = UIImage(named: "possible_light_rain")
            break
        case "Rain And Humid":
            cell.collectionCellImage.image = UIImage(named: "rain_and_humid")
            break
        case "Humid And Foggy":
            cell.collectionCellImage.image = UIImage(named: "humid_and_foggy")
            break
        case "Humid":
            cell.collectionCellImage.image = UIImage(named: "humid")
            break;
        case "Humid and Overcast":
            cell.collectionCellImage.image = UIImage(named: "humid_and_overcast")
            break
        case "Partly Cloudy":
            cell.collectionCellImage.image = UIImage(named: "partly_cloudy")
            break
        case "Humid and Mostly Cloudy":
            cell.collectionCellImage.image = UIImage(named: "humid_and_mostly_cloudy")
            break
        case "Humid and Partly Cloudy":
            cell.collectionCellImage.image = UIImage(named: "humid_and_partly_cloudy")
            break
        case "Mostly Cloudy":
            cell.collectionCellImage.image = UIImage(named: "mostly_cloudy")
            break
        case "Overcast":
            cell.collectionCellImage.image = UIImage(named: "overcast")
            break
        case "Clear":
            cell.collectionCellImage.image = UIImage(named: "clear")
            break
        default:
            cell.collectionCellImage.image = UIImage(named: "default")
            break
        }
    }
    
    private func setCellImage(cell: DailyTemparatureCellTableViewCell, indexPath: IndexPath){
        let weather = weatherForeCast?.hourly.data[indexPath.row]
        print(weather?.summary ?? "nil")
        switch(weather?.summary){
        case "Humid And Overcast":
            cell.dailyTempImg.image = UIImage(named: "humid_and_overcast")
            break
        case "Light Rain And Humid":
            cell.dailyTempImg.image = UIImage(named: "light_Rain_and_humid")
            break
        case "Possible Drizzle and Humid":
            cell.dailyTempImg.image = UIImage(named: "possible_drizzle_and_humid")
            break
        case "Possible Light Rain and Humid":
            cell.dailyTempImg.image = UIImage(named: "possible_light_rain_and_humid")
            break
        case "Possible Light Rain":
            cell.dailyTempImg.image = UIImage(named: "possible_light_rain")
            break
        case "Rain And Humid":
            cell.dailyTempImg.image = UIImage(named: "rain_and_humid")
            break
        case "Humid And Foggy":
            cell.dailyTempImg.image = UIImage(named: "humid_and_foggy")
            break
        case "Humid":
            cell.dailyTempImg.image = UIImage(named: "humid")
            break;
        case "Humid and Overcast":
            cell.dailyTempImg.image = UIImage(named: "humid_and_overcast")
            break
        case "Partly Cloudy":
            cell.dailyTempImg.image = UIImage(named: "partly_cloudy")
            break
        case "Humid and Mostly Cloudy":
            cell.dailyTempImg.image = UIImage(named: "humid_and_mostly_cloudy")
            break
        case "Humid and Partly Cloudy":
            cell.dailyTempImg.image = UIImage(named: "humid_and_partly_cloudy")
            break
        case "Mostly Cloudy":
            cell.dailyTempImg.image = UIImage(named: "mostly_cloudy")
            break
        case "Overcast":
            cell.dailyTempImg.image = UIImage(named: "overcast")
            break
        case "Clear":
            cell.dailyTempImg.image = UIImage(named: "clear")
            break
        default:
            cell.dailyTempImg.image = UIImage(named: "default")
            break
        }
    }
    
    private func getDate(unixdate: Int) -> String {
        if unixdate == 0 {return "Empty String"}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return "\(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(unixdate))))"
    }
    
    private func getDayName(unixdate: Int) -> String {
        if unixdate == 0 {return "Empty String"}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return "\(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(unixdate))))"
    }

}

extension DetailsCityWeather: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForeCast?.daily.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTemparatureCellTableViewCell", for: indexPath) as! DailyTemparatureCellTableViewCell

        if let weather = weatherForeCast?.daily.data[indexPath.row] {
            cell.dailyMaxTemp.text = String(format: "%.0f",5/9 * (weather.temperatureMax-32))+("℃")
            cell.dailyMinTemp.text = String(format: "%.0f",5/9 * (weather.temperatureLow-32))+("℃")
            cell.dayName.text = getDayName(unixdate: weather.time)
            setCellImage(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
