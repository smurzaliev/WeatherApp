//
//  SearchModel.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 20.02.2022.
//

import Foundation

struct SearchModel: Codable {
    let version: Int?
    let key: String?
    let type: String?
    let rank: Int?
    let localizedName: String?
    let country, administrativeArea: AdministrativeArea?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let id, localizedName: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
    }
}
