//
//  NetworkManager.swift
//  Clima2
//
//  Created by Adit Salim on 29/01/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let openweatherBaseUrl = "https://api.openweathermap.org/data/2.5/"
    private let openweatherAPPID = "" // add your key here
    
    private func genericApi<T: Codable>(with urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw ClimaError.invalidData }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let listData = try JSONDecoder().decode(T.self, from: data)
            
            return listData
        } catch {
            throw ClimaError.unknownError
        }
    }
    
    private func genericApi<T: Codable>(with urlRequest: URLRequest) async throws -> T {
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let listData = try JSONDecoder().decode(T.self, from: data)
            
            return listData
        } catch {
            throw ClimaError.unknownError
        }
    }
    
    func fetchCityNameAutoComplete(query: String) async throws -> [City] {
        let filterString = """
        {
            "name": {
                "$regex": "(?i)\(query)"
            }
        }
        """
        
        guard let filter = filterString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        
        let urlString = "https://parseapi.back4app.com/classes/City?limit=10&include=country&keys=name,country.name,cityId&where=\(filter)"
        let appID = "" // add your key here
        let masterKey = "" // add your key here

        guard let url = URL(string: urlString) else { return [] }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(appID, forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.setValue(masterKey, forHTTPHeaderField: "X-Parse-Master-Key")
        
        do {
            let data: CityResult = try await self.genericApi(with: urlRequest)
            return data.results
        } catch {
            return []
        }
    }
    
    func fetchCurrentWeather(for city: String) async throws -> CurrentWeather {
        let urlString = "\(openweatherBaseUrl)weather?appid=\(openweatherAPPID)&units=metric&q=\(city)"
        
        do {
            let data: CurrentWeather = try await self.genericApi(with: urlString)
            return data
        } catch {
            throw ClimaError.invalidData
        }
        
    }
    
    func fetchForecast(for city: String) async throws -> WeatherForecast {
        let urlString = "\(openweatherBaseUrl)forecast?appid=\(openweatherAPPID)&units=metric&q=\(city)&cnt=5"
        
        do {
            let data: WeatherForecast = try await self.genericApi(with: urlString)
            return data
        } catch {
            throw ClimaError.invalidData
        }
    }
}
