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
        
//    func addCity(in realm: Realm, city: City) {
//        
//        let addCity = City()
//        addCity.id = city.cityNumber
//        addCity.cityNumber = city.cityNumber
//        addCity.cityName = city.cityName
//        addCity.cityType = city.cityType
//        addCity.cityCountry = city.cityCountry
//                
//        try! realm.write {
//            realm.add(addCity)
//        }
//    }
    
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
