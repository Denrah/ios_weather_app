//
//  WeatherViewModel.swift
//  ios_weather_app
//
//  Created by iOS Intern on 05/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import Foundation

class WeatherViewModel {
    weak var coordinatorDelegate: WeatherCoordinator?
    
    var loadingInProgress = Dynamic<Bool>(true)
    var weather = Dynamic<Weather>(nil)
    var city = Dynamic<String>(nil)
    
    init(city: String) {
        self.city.value = city
    }
    
    func getWeather() {
        guard let city = city.value else {return}
        loadingInProgress.value = true
        ApiService.getWeatherByCity(city: city) { (weather) in
            self.loadingInProgress.value = false
            guard let weather = weather else {return}
            self.weather.value = weather
        }
    }
}
