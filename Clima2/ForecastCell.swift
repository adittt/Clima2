//
//  ForecastCell.swift
//  Clima2
//
//  Created by Adit Salim on 02/02/24.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    static let reuseID = "ForecastCell"
    
    let temperatureLabel = UILabel(frame: .zero)
    let weatherIcon = UIImageView(frame: .zero)
    let timeLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTemperatureLabel()
        configureWeatherIcon()
        configureTimeLabel()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(weather: CityWeather) {
        temperatureLabel.text = "\(weather.main.roundedTemp)°"
        
        if let weatherIconName = weather.weather.first?.conditionName {
            weatherIcon.image = UIImage(systemName: weatherIconName, withConfiguration: UIImage.SymbolConfiguration(weight: .thin))
        }
        
        let date = Date(timeIntervalSince1970: Double(weather.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = "\(dateFormatter.string(from: date))"
    }
    
    private func configureTemperatureLabel() {
        temperatureLabel.text = "26°"
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .white
    }
    
    private func configureWeatherIcon() {
        weatherIcon.image = UIImage(systemName: "cloud")
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.tintColor = .white
    }
    
    private func configureTimeLabel() {
        timeLabel.text = "15:00"
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
    }
    
    private func configure() {
        addSubview(temperatureLabel)
        addSubview(weatherIcon)
        addSubview(timeLabel)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 15),
            
            weatherIcon.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5),
            weatherIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 60),
            
            timeLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 5),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
