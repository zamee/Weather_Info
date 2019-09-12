//
//  CityStore.swift
//  Weather_Info
//
//  Created by Ahmad Hussain Zamee on 9/9/19.
//  Copyright © 2019 Ahmad Hussain Zamee. All rights reserved.
//

import Foundation
import RealmSwift

class CityStore {
    var realm : Realm = try! Realm()
    
    func makeNewCity(city: String, lat: Double, lng: Double) -> City {
        let newCity = City()
        newCity.name = city
        newCity.lat = lat
        newCity.lng = lng
        return newCity
    }
    
    func saveNewCity(city: City) -> Bool {
        try! realm.write {
            realm.add(city)
        }
        return true
    }
    
    func getCityByTitle(title: String) throws -> Results<City> {
        let predicate = NSPredicate(format: "title = %@", title)
        return realm.objects(City.self).filter(predicate)
    }
    
    func getAllCity() -> Results<City> {
        return self.realm.objects(City.self)
    }
    
    func updateCityByTitle(title: String, currentValue: String, updatedValue: String) throws {
        let city = try findCitisByField(field: title, value: currentValue)
        try! realm.write {
            city.setValue(updatedValue, forKey: "\(title)")
        }
    }
    
    private func findCitisByField(field : String, value : String) throws -> Results<City>
    {
        let predicate = NSPredicate(format: "%K = %@", field, value)
        return realm.objects(City.self).filter(predicate)
    }
    
    func deleteCity(city: City) throws {
        try! realm.write {
            realm.delete(city)
        }
    }
}
