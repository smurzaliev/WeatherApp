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
    
    private let apiKey = "YS7mx8TJj5n3s2q6Da5W3hv5BQD3ld9L"

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setView()
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

