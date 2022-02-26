//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Samat Murzaliev on 20.02.2022.
//

import Foundation
import UIKit
import MaterialComponents

class WeatherCell: UITableViewCell {
    
    private lazy var dayTemp: UILabel = {
            let view = UILabel()
            view.textColor = .white
            view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return view
        }()
        
        private lazy var nightTemp: UILabel = {
            let view = UILabel()
            view.textColor = .lightGray
            view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return view
        }()
        
    private lazy var iconWeather: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
        
        override func layoutSubviews() {
            setView() 
        }
    
    private func setView() {
        addSubview(dayTemp)
        dayTemp.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(80)
            make.centerY.equalToSuperview()
        }
    
        addSubview(nightTemp)
        nightTemp.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-80)
            make.centerY.equalToSuperview()
        }
        
        addSubview(iconWeather)
        iconWeather.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    func fill(dayOne: DailyForecast?) {
            dayTemp.text = "\(dayOne?.temperature?.maximum?.value ?? 0) °C"
            nightTemp.text = "\(dayOne?.temperature?.minimum?.value ?? 0 ) °C"
            let icon = dayOne?.night?.icon
            if (icon ?? 0) > 9 {
                iconWeather.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/\((icon ?? 0))-s.png")!)
            } else {
                iconWeather.kf.setImage(with: URL(string: "https://developer.accuweather.com/sites/default/files/0\((icon ?? 0))-s.png")!)
            }
        }
}
