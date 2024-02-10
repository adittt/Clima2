//
//  ViewController.swift
//  Clima2
//
//  Created by Adit Salim on 29/01/24.
//

import UIKit
import CoreLocation

protocol ViewControllerDelegate: AnyObject {
    func updateLocationAndTemperature(city: City, weather: CurrentWeather)
    func updateCityWeatherForecast(weatherForecast: WeatherForecast)
    func dismissSearchController()
}

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let scrollViewContentView = UIView()
    
    let refreshController = UIRefreshControl()
    
    let resultVC = ResultsVC()
    var searchVC: UISearchController!
    var currentCityName: String!
    let weatherIcon = UIImageView()
    let temperatureView = TemperatureView(frame: .zero)
    let cityView = CityView(frame: .zero)
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, CityWeather>!
    
    let geoCoder = CLGeocoder()
    var currentLocation: CLLocation!
    let locationManager = CLLocationManager()
    var longitude: CLLocationDegrees!
    var latitude: CLLocationDegrees!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configureRefreshController()
        configureSearchVC()
        configureLocationView()
        configureWeatherIcon()
        configureTemperatureView()
        configureCollectionView()
        configureDataSource()
        
        getCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let searchFieldFrame = navigationItem.titleView!.frame
        
//        let searchFieldFrame = navigationItem.searchController!.searchBar.searchTextField.frame
        resultVC.setTableFrame(frame: CGRect(
            x: searchFieldFrame.origin.x + 15,
            y: searchFieldFrame.origin.y + 105,
            width: searchFieldFrame.width.rounded() - 30,
            height: 300)
        )
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        let weather1 = Weather(description: "Cloudy", id: 100)
//        let weather2 = Weather(description: "Cloudy", id: 100)
//        
//        let weatherForecast: [CityWeather] = [
//            CityWeather(dt: 1707134400, main: Main(temp: 26), weather: [weather1]),
//            CityWeather(dt: 1707145200, main: Main(temp: 20), weather: [weather2])
//        ]
//        updateWeatherForecast(weatherForecast: weatherForecast)
//    }
    
    private func configureRefreshController() {
        refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshController.addTarget(self, action: #selector(refetchWeatherData), for: .valueChanged)
        scrollView.refreshControl = refreshController
    }
    
    @objc func refetchWeatherData() {
        
        refreshController.endRefreshing()
    }
    
    private func configureVC() {
        let bgImage = UIImageView(frame: view.bounds)
        bgImage.image = UIImage(named: "background")
        bgImage.contentMode = .scaleAspectFill
        view.insertSubview(bgImage, at: 0)
        
        scrollView.frame = view.bounds
        scrollView.isScrollEnabled = true
        
        scrollViewContentView.frame = scrollView.bounds
        scrollView.addSubview(scrollViewContentView)
        
        view.addSubview(scrollView)
    }
    
    private func configureSearchVC() {
        resultVC.delegate = self
        searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.setNeedsStatusBarAppearanceUpdate()
        searchVC.hidesNavigationBarDuringPresentation = false
        
        navigationItem.titleView = searchVC.searchBar
//        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationItem.preferredSearchBarPlacement = .inline
    }
    
    private func configureWeatherIcon() {
        weatherIcon.image = UIImage(systemName: "sun.max")
        weatherIcon.tintColor = .white
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        
        scrollViewContentView.addSubview(weatherIcon)
        
        NSLayoutConstraint.activate([
            weatherIcon.topAnchor.constraint(equalTo: cityView.bottomAnchor, constant: 10),
            weatherIcon.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -20),
            weatherIcon.widthAnchor.constraint(equalToConstant: 120),
            weatherIcon.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureTemperatureView() {
        scrollViewContentView.addSubview(temperatureView)
        
        NSLayoutConstraint.activate([
            temperatureView.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 7),
            temperatureView.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -20),
            temperatureView.widthAnchor.constraint(equalToConstant: 260),
            temperatureView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureLocationView() {
        scrollViewContentView.addSubview(cityView)
        cityView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityView.topAnchor.constraint(equalTo: scrollViewContentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityView.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor, constant: 20),
            cityView.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -100),
            cityView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 60, height: 100)
        
        return layout
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        scrollViewContentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 15
        
        // create blur effect
        let uiBlur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: uiBlur)
        blurView.frame = collectionView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundView = blurView
        collectionView.backgroundColor = .none
        collectionView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseID)
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor, constant: -150),
            collectionView.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CityWeather>(collectionView: collectionView, cellProvider: { collectionView, indexPath, cityWeather in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseID, for: indexPath) as! ForecastCell
            cell.set(weather: cityWeather)
            
            return cell
        })
    }
    
    private func updateWeatherForecast(weatherForecast: [CityWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CityWeather>()
        snapshot.appendSections([1])
        snapshot.appendItems(weatherForecast)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func getCurrentLocation() {
        locationManager.delegate = self
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
    }

}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, query.count > 2 else {
            return
        }
        
        guard let resultsVC = searchController.searchResultsController as? ResultsVC else {
            return
        }
        
        Task {
            let data = try await NetworkManager.shared.fetchCityNameAutoComplete(query: query)
            resultsVC.update(with: data)
        }
    }
    
}

extension ViewController: ViewControllerDelegate {
    func updateLocationAndTemperature(city: City, weather: CurrentWeather) {
        currentCityName = city.name
        if let weatherIconName = weather.weather.first?.conditionName {
            
            if let aniImage = UIImage(systemName: weatherIconName)?.withRenderingMode(.alwaysTemplate) {
                weatherIcon.setSymbolImage(aniImage, contentTransition: .replace)
                weatherIcon.addSymbolEffect(.variableColor.iterative, options: .nonRepeating)
            }

        }
        
        cityView.set(cityName: city.name, countryName: city.country.name)
        temperatureView.setTemperature(temperature: weather.main.roundedTemp)
    }
    
    func updateCityWeatherForecast(weatherForecast: WeatherForecast) {
        updateWeatherForecast(weatherForecast: weatherForecast.list)
    }
    
    func dismissSearchController() {
        searchVC.isActive = false
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            if latitude != nil && longitude != nil {
                currentLocation = CLLocation(latitude: latitude, longitude: longitude)
                geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, _) -> Void in
                    placemarks?.forEach({ placemark in
                        if let currentCity = placemark.locality, let currentCountry = placemark.country {
                            
                            // -------------------------------------
                            self.currentCityName = currentCity
                            let countryObj = Country(name: currentCountry)
                            let cityObj = City(cityId: 1, name: currentCity, country: countryObj)
                            Task {
                                let weather = try await NetworkManager.shared.fetchCurrentWeather(for: currentCity)
                                self.updateLocationAndTemperature(city: cityObj, weather: weather)
                            }
                            
                            Task {
                                let forecast = try await NetworkManager.shared.fetchForecast(for: currentCity)
                                self.updateCityWeatherForecast(weatherForecast: forecast)
                            }
                            // -------------------------------------
                            
                        }
                    })
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

