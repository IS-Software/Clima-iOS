//
//  WeatherManager.swift
//  Clima
//
//  Created by Nikita Gavrilov 06.12.2021
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    let apiKey = "SECRET" // to check this solution get your API at openweathermap.org
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid="
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)\(apiKey)&units=metric&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let urlString = "\(weatherURL)\(apiKey)&units=metric&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let description = decodedData.weather[0].description
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            return WeatherModel(cityName: name, temperature: temp, conditionId: id, description: description)
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
