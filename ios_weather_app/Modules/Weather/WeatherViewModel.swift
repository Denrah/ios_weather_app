//
//  WeatherViewModel.swift
//  ios_weather_app
//

import Foundation

class WeatherViewModel {
  weak var coordinatorDelegate: WeatherCoordinator?
  
  let loadingInProgress = Dynamic<Bool>(true)
  let weather = Dynamic<Weather>(nil)
  let city = Dynamic<String>(nil)
  
  private let apiService: ApiService
  
  init(apiService: ApiService, city: String) {
    self.city.value = city
    self.apiService = apiService
  }
  
  func getWeather() {
    guard let city = city.value else {return}
    loadingInProgress.value = true
    apiService.getWeatherByCity(city: city) { weather in
      self.loadingInProgress.value = false
      self.weather.value = weather
    }
  }
  
  func goBack() {
    coordinatorDelegate?.finish()
  }
}
