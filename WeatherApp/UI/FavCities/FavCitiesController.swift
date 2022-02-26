//
//  FavCitiesController.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 23.02.2022.
//

import UIKit
import SnapKit
import MaterialComponents
import RealmSwift


class FavCitiesController: UIViewController {
    
    private var document = SearchDocument()
    
    let realm = try! Realm()
    
//    var cities: Results<City>
    
    private lazy var backButton: MDCButton = {
        let view = MDCButton(type: .system)
        let containerScheme = MDCContainerScheme()
        view.applyContainedTheme(withScheme: containerScheme)
        view.setTitle("Clear list", for: .normal)
        view.setTitle("Back", for: .normal)
        view.addTarget(self, action: #selector(backTapped(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var clearButton: MDCButton = {
        let view = MDCButton(type: .system)
        let containerScheme = MDCContainerScheme()
        view.applyContainedTheme(withScheme: containerScheme)
        view.setTitle("Clear list", for: .normal)
        view.addTarget(self, action: #selector(clearTapped(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var citiesTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(FavCitiesCell.self, forCellReuseIdentifier: "FavCitiesCell")
        view.backgroundColor = .clear
        return view
    }()
    
    @objc func clearTapped(view: UIButton) {
        document.clearCities()
        citiesTable.reloadData()
    }
    
    @objc func backTapped(view: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        setView()
        setSubViews()
    }
    
    private func setView() {
        view.backgroundColor = UIColor(named: "AccentOne")
    }
    
    private func setSubViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(45)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        view.addSubview(citiesTable)
        citiesTable.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(10)
        }
    }
}

extension FavCitiesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cities = realm.objects(City.self)

        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cities = realm.objects(City.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCitiesCell", for: indexPath) as! FavCitiesCell
        cell.cityName.text = cities[index].cityName
        cell.cityType.text = cities[index].cityType
        cell.cityCoutry.text = cities[index].cityCountry
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cities = realm.objects(City.self)
        try! realm.write {
            realm.add(cities[indexPath.row])
        }
        document.setDefaultCity(in: realm, city: cities[indexPath.row])
        navigationController?.popViewController(animated: true)
        
    }
}
