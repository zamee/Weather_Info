//
//  DetailsCityWeatherViewController.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 7/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import UIKit
import Alamofire

class DetailsCityWeather: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
                    print("\(weather.daily.data[0].apparentTemperatureHigh) with \(weather.currently.temperature)℃")
                }catch{
                    print(value)
                }
            }
        }
    }

}
