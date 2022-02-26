//
//  SearchDocument.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 23.02.2022.
//

import Foundation
import RealmSwift

class SearchDocument {
    
    let realm = try! Realm()

    func clearCities() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func createDefaulCity(in realm: Realm) -> City {
        let defaultCity = City()
        defaultCity.id = "default"
        try! realm.write{
            realm.add(defaultCity)
        }
        return defaultCity
    }
    
    func setDefaultCity(in realm: Realm, city: City) {
        let defaultCity = defaultCity(in: realm)
        try! realm.write{
            defaultCity.cityName = city.cityName
            defaultCity.cityNumber = city.cityNumber
            defaultCity.cityType = city.cityType
            defaultCity.cityCountry = city.cityCountry
        }
    }
    
    func defaultCity(in realm: Realm) -> City {
        return realm.object(ofType: City.self, forPrimaryKey: "default") ?? createDefaulCity(in: realm)
    }
}
