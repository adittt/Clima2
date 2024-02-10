//
//  TemperatureView.swift
//  Clima2
//
//  Created by Adit Salim on 31/01/24.
//

import UIKit

class TemperatureView: UIView {
    
    let stackView = UIStackView()
    let temperatureLabel = UILabel(frame: .zero)
    let degreeSymbolLabel = UILabel(frame: .zero)
    let celciusLabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        configureStackView()
        configureLabel()
    }
    
//    init(temperature: Double) {
//        super.init(frame: .zero)
//        
//        temperatureLabel.text = "\(temperature)"
//        configureStackView()
//        configureLabel()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTemperature(temperature: String) {
        temperatureLabel.text = temperature
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(degreeSymbolLabel)
        stackView.addArrangedSubview(celciusLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureLabel() {
        temperatureLabel.text = "27.8"
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .right
        temperatureLabel.font = UIFont.systemFont(ofSize: 80)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        degreeSymbolLabel.text = "°"
        degreeSymbolLabel.textColor = .white
        degreeSymbolLabel.font = UIFont.systemFont(ofSize: 100)
        degreeSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        
        celciusLabel.text = "C"
        celciusLabel.textColor = .white
        celciusLabel.font = UIFont.systemFont(ofSize: 100)
        celciusLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
