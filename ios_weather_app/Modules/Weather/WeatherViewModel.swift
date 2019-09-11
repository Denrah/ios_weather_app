//
//  WeatherViewModel.swift
//  ios_weather_app
//

import UIKit

protocol WeatherViewModelDelegate: class {
  func weatherViewModelDidFinish(_ viewModel: WeatherViewModel)
}

class WeatherViewModel {
  weak var delegate: WeatherViewModelDelegate?
  
  let loadingInProgress = Dynamic<Bool>(true)
  let city = Dynamic<String>(nil)
  let weatherState = Dynamic<WeatherState>(nil)
  let apiError = Dynamic<Error>(nil)
  
  private let apiService: ApiService
  private var weatherImages: WeatherImages
  
  private enum WeatherConstants {
    static let placeholder = "-"
  }
  
  init(apiService: ApiService, city: String) {
    self.city.value = city
    self.apiService = apiService
    self.weatherImages = WeatherImages()
    self.setupWeatherImages()
  }
  
  func setupWeatherImages() {
    weatherImages.append(range: 200...232, image: #imageLiteral(resourceName: "thunderstorm"))
    weatherImages.append(range: 300...321, image: #imageLiteral(resourceName: "showerrain"))
    weatherImages.append(range: 520...531, image: #imageLiteral(resourceName: "showerrain"))
    weatherImages.append(range: 500...511, image: #imageLiteral(resourceName: "rain"))
    weatherImages.append(range: 600...622, image: #imageLiteral(resourceName: "snow"))
    weatherImages.append(range: 701...781, image: #imageLiteral(resourceName: "mist"))
    weatherImages.append(range: 800...800, image: #imageLiteral(resourceName: "clearsky"))
    weatherImages.append(range: 801...801, image: #imageLiteral(resourceName: "fewclouds"))
    weatherImages.append(range: 802...802, image: #imageLiteral(resourceName: "scatteredclouds"))
    weatherImages.append(range: 803...804, image: #imageLiteral(resourceName: "brokenclouds"))
  }
  
  func getWeather() {
    guard let city = city.value else { return }
    loadingInProgress.value = true
    apiService.getWeatherByCity(city: city) { result in
      self.loadingInProgress.value = false
      switch result {
      case .success(let weather):
        self.updateWeather(weather: weather)
      case .failure(let error):
        self.apiError.value = error
      }
    }
  }
  
  private func updateWeather(weather: Weather) {
    var state = WeatherState()
    
    if let temperature = weather.details?.temperature {
      state.temperature = "\(Int(temperature))"
    } else {
      state.temperature = WeatherConstants.placeholder
    }
    
    if let humidity = weather.details?.humidity {
      state.humidity = "\(humidity.removeZerosFromEnd())%"
    } else {
      state.humidity = WeatherConstants.placeholder
    }
    
    if let pressure = weather.details?.pressure {
      state.pressure = "\(pressure.removeZerosFromEnd()) mm Hg"
    } else {
      state.pressure = WeatherConstants.placeholder
    }
    
    let windDirection = weather.wind?.direction?.compassDirection ?? ""
    let windSpeed = weather.wind?.speed?.removeZerosFromEnd() ?? WeatherConstants.placeholder
    state.wind = "\(windDirection) \(windSpeed) m/s"
    state.weathrDescription = weather.info?.first?.description?.capitalized ?? WeatherConstants.placeholder
    
    if let icon = weather.info?.first?.icon {
      state.weathrIcon = URL(string: "\(Constants.apiIconsUrl)/img/wn/\(icon)@2x.png")
    }
    if let id = weather.info?.first?.id {
      state.weatherImage = self.weatherImages[id]
    }
    self.weatherState.value = state
  }
  
  func goBack() {
    delegate?.weatherViewModelDidFinish(self)
  }
}
