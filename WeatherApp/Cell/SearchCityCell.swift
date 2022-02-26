//
//  SearchCityCell.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 20.02.2022.
//

import UIKit

class SearchCityCell: UITableViewCell {
    
    private lazy var cityName: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.text = "Biskek"
        return view
    }()
    
    private lazy var cityType: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.text = "City"
        return view
    }()
    
    private lazy var cityCoutry: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.text = "Kyrgistan"
        return view
    }()
    
    private lazy var containerView = UIView()
    
    override func layoutSubviews() {
        setView()
    }
    
    private func setView() {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .darkGray
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addSubview(cityName)
        cityName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
        }
        
        containerView.addSubview(cityType)
        cityType.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
        }
        
        containerView.addSubview(cityCoutry)
        cityCoutry.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    func fill(model: SearchModel?) {
        cityName.text = model?.localizedName
        cityType.text = model?.type
        cityCoutry.text = model?.country?.localizedName
    }
}
