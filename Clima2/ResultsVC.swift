//
//  ResultsVC.swift
//  Clima2
//
//  Created by Adit Salim on 29/01/24.
//

import UIKit

class ResultsVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var cities: [City] = []
    
    weak var delegate: ViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//        tableView.frame = CGRect(x: 0, y: 80, width: 320, height: 120)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setTableFrame(frame: CGRect) {
        tableView.frame = frame
    }
    
    func update(with cities: [City]) {
        self.cities = cities
        tableView.reloadData()
    }
}

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 31/255, green: 37/255, blue: 68/255, alpha: 1.0)
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(cities[indexPath.row].name), \(cities[indexPath.row].country.name)"
        content.textProperties.color = .white
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityName = cities[indexPath.row].name
        
        // get current weather
        Task {
            let weather = try await NetworkManager.shared.fetchCurrentWeather(for: cityName)
            delegate.updateLocationAndTemperature(city: cities[indexPath.row], weather: weather)
        }
        
        Task {
            let forecast = try await NetworkManager.shared.fetchForecast(for: cityName)
            delegate.updateCityWeatherForecast(weatherForecast: forecast)
        }

        delegate.dismissSearchController()
    }
}
