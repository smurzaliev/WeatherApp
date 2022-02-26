//
//  SearchController.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 20.02.2022.
//

import UIKit
import SnapKit
import MaterialComponents
import RealmSwift

class SearchController: UIViewController {
    
    private var document = SearchDocument()
    
    private lazy var searchField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.backgroundColor = .black
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 20)
        view.attributedPlaceholder =
        NSAttributedString(string: "City name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        view.leftViewMode = .always
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.autocorrectionType = .no
        return view
    }()
    
    private lazy var searchButton: MDCButton = {
        let view = MDCButton(type: .system)
        let containerScheme = MDCContainerScheme()
        view.applyContainedTheme(withScheme: containerScheme)
        view.setTitle("Search", for: .normal)
        view.addTarget(self, action: #selector(clickSearch(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var searchTable: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    
    private var models: [SearchModel]? = nil
    
    @objc func clickSearch(view: UIButton) {
        getSearchCity()
    }
    
    private func getSearchCity() {
        
        var url = URLComponents(string: "http://dataservice.accuweather.com/locations/v1/cities/autocomplete")!
        url.queryItems = [
            URLQueryItem(name: "q", value: searchField.text ?? String()),
            URLQueryItem(name: "apikey", value: "mAitxnyzvA8vyWt6quAPGoIKbJ3rRhQe"),
            URLQueryItem(name: "language", value: "en"),
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let model = try JSONDecoder().decode([SearchModel].self, from: data)
                    
                    self.models = model
                    DispatchQueue.main.async {
                        self.searchTable.reloadData()
                    }
                }
            } catch {
                
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        
        
        view.backgroundColor = UIColor(named: "AccentOne")
        setSubViews()
        
    }
    
    private func setSubViews() {
                    
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.left.equalTo(searchField.snp.right).offset(10)
        }
        
        view.addSubview(searchTable)
        searchTable.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom).offset(16)
        }
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models?[indexPath.row]
        
        if let model = model {
            let addCity = City()
            addCity.id = model.key ?? String()
            addCity.cityNumber = model.key ?? String()
            addCity.cityName = model.localizedName ?? String()
            addCity.cityType = model.type ?? String()
            addCity.cityCountry = model.country?.localizedName ?? String()
            let realm = try! Realm()
            try! realm.write {
                realm.add(addCity)
            }
            document.setDefaultCity(in: realm, city: addCity)
            navigationController?.pushViewController(MainController(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models?[indexPath.row]
        let cell = SearchCityCell()
        cell.fill(model: model)
        return cell
    }
    
}
