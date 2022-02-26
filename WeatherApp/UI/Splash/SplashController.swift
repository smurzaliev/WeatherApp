//
//  ViewController.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 20.02.2022.
//

import UIKit
import SnapKit
import RealmSwift

class SplashController: UIViewController {
    
    let document = SearchDocument()
    
    private let apiKey = "mAitxnyzvA8vyWt6quAPGoIKbJ3rRhQe"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setView() {
        view.backgroundColor = .black
        let realm = try! Realm()
        let defaultCity = document.defaultCity(in: realm)
        
        if defaultCity.cityNumber != "" {
            navigationController?.pushViewController(MainController(), animated: true)
        } else {
            navigationController?.pushViewController(SearchController(), animated: true)
        }
    }
}

