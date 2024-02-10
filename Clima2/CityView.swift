//
//  CityView.swift
//  Clima2
//
//  Created by Adit Salim on 31/01/24.
//

import UIKit

class CityView: UIView {
    
    let pinIcon = UIImageView()
    let cityLabel = UILabel()
    let countryLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurePinIcon()
        configureCityLabel()
        configureCountryLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cityName: String, countryName: String) {
        cityLabel.text = cityName
        countryLabel.text = countryName
    }
    
    private func configurePinIcon() {
        pinIcon.image = UIImage(systemName: "mappin.and.ellipse")
//        pinIcon.image = UIImage(systemName: "mappin")
        pinIcon.tintColor = .white
        pinIcon.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pinIcon)
        
        NSLayoutConstraint.activate([
            pinIcon.topAnchor.constraint(equalTo: topAnchor),
            pinIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            pinIcon.widthAnchor.constraint(equalToConstant: 37),
            pinIcon.heightAnchor.constraint(equalToConstant: 37)
        ])
        
    }
    
    private func configureCityLabel() {
        cityLabel.text = "Jakarta"
        cityLabel.textColor = .white
        cityLabel.font = UIFont.preferredFont(for: .largeTitle, weight: .bold)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: pinIcon.trailingAnchor, constant: 5),
            cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            cityLabel.heightAnchor.constraint(equalToConstant: 37)
        ])
    }
    
    private func configureCountryLabel() {
        countryLabel.text = "Indonesia"
        countryLabel.textColor = .white
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countryLabel)
        
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 1),
            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countryLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
