//
//  City.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 27.02.2022.
//

import Foundation
import RealmSwift

class City: Object {
    @objc dynamic var id = ""
    @objc dynamic var cityNumber = ""
    @objc dynamic var cityName = ""
    @objc dynamic var cityType = ""
    @objc dynamic var cityCountry = ""
    
    override static func primaryKey() -> String? {
        "id"
    }
}
