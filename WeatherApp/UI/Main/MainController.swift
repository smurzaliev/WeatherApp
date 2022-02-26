//
//  MainController.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 20.02.2022.
//

import Foundation
import UIKit
import Kingfisher
import MaterialComponents
import RealmSwift


class MainController: UIViewController {
    
    let realm = try! Realm()
    
    private var document = SearchDocument()
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "background"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleCity: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        return view
    }()
    
    private lazy var iconTemp: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var tempLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return view
    }()
    
    private lazy var averageTempLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.text = "Average 10c"
        return view
    }()
    
    private lazy var dayForecastTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var citiesButton: MDCButton = {
        let view = MDCButton(type: .system)
        let containerScheme = MDCContainerScheme()
        view.setTitle("Added cities", for: .normal)
        view.applyContainedTheme(withScheme: containerScheme)
        view.addTarget(self, action: #selector(citiesPressed(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var backButton: MDCButton = {
        let view = MDCButton(type: .system)
        let containerScheme = MDCContainerScheme()
        view.setTitle("New Search", for: .normal)
        view.applyContainedTheme(withScheme: containerScheme)
        view.addTarget(self, action: #selector(newSearch(view:)), for: .touchUpInside)
        return view
    }()
    
    @objc func citiesPressed(view: UIButton) {
        navigationController?.pushViewController(FavCitiesController(), animated: true)
    }
    
    @objc func newSearch(view: UIButton) {
        navigationController?.pushViewController(SearchController(), animated: true)
    }
    
    var dailyForecast: [DailyForecast]? = nil
    
    override func viewDidLoad() {
        
        setView()
        setSubViews()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setView()
        setSubViews()
    }
    private func setView() {
        
        view.backgroundColor = UIColor(named: "AccentOne")

    }
    
    private func setSubViews() {
        
        view.addSubview(citiesButton)
        citiesButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(45)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(titleCity)
        titleCity.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeArea.top).offset(120)
        }
        
        view.addSubview(iconTemp)
        iconTemp.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleCity.snp.bottom).offset(10)
            make.height.width.equalTo(90)
        }
        
        view.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.iconTemp.snp.bottom).offset(10)
        }
        
        view.addSubview(averageTempLabel)
        averageTempLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tempLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(dayForecastTable)
        dayForecastTable.snp.makeConstraints { make in
            make.top.equalTo(averageTempLabel.snp.bottom).offset(35)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
        
        getWeather()
    }
    
    private func getWeather() {
        
        let defaultCity = realm.object(ofType: City.self, forPrimaryKey: "default")
        let cityKey = defaultCity?.cityNumber ?? String()
        print(cityKey)
        titleCity.text = defaultCity?.cityName
        var url = URLComponents(string: "http://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityKey)")!
        url.queryItems = [
            URLQueryItem(name: "apikey", value: "mAitxnyzvA8vyWt6quAPGoIKbJ3rRhQe"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "details", value: "false"),
            URLQueryItem(name: "metric", value: "true"),
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let model = try JSONDecoder().decode(WeaherModel.self, from: data)
                    dump(model)
                    DispatchQueue.main.async {
                        self.setupView(model: model)
                    }
                }
            } catch {
                
            }
        }.resume()
    }
    
    func setupView(model: WeaherModel?) {
        let dayOne = model?.dailyForecasts?[0]
        tempLabel.text = "\(dayOne?.temperature?.maximum?.value ?? 0)C / \(dayOne?.temperature?.minimum?.value ?? 0 )C"
        let s = String(format: "%.2f", ((dayOne?.temperature?.maximum?.value ?? 0) + (dayOne?.temperature?.minimum?.value ?? 0 )) / 2)
        averageTempLabel.text = "Average \(s)C"
        let icon = dayOne?.night?.icon
        if (icon ?? 0) > 9 {
            iconTemp.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/\((icon ?? 0))-s.png")!)
        } else {
            iconTemp.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/0\((icon ?? 0))-s.png")!)
        }
        var newModel =  model?.dailyForecasts
        newModel?.remove(at: 0)
        self.dailyForecast = newModel
        dayForecastTable.reloadData()
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dailyForecast?[indexPath.row]
        let cell = WeatherCell()
        cell.fill(dayOne: model)
        return cell
    }
}
