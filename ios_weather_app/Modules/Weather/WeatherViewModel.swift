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
  let weatherImage = Dynamic<UIImage>(nil)
  let weatherIcon = Dynamic<URL>(nil)
  let temperature = Dynamic<String>(nil)
  let humidity = Dynamic<String>(nil)
  let wind = Dynamic<String>(nil)
  let pressure = Dynamic<String>(nil)
  let weatherDescription = Dynamic<String>(nil)
  let apiError = Dynamic<Error>(nil)
  
  private let apiService: ApiService
  private var weatherImages: WeatherImages
  
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
        
        if let temperature = weather.details?.temperature {
          self.temperature.value = "\(Int(temperature))"
        }
        if let humidity = weather.details?.humidity {
          self.humidity.value = "\(humidity.removeZerosFromEnd())%"
        }
        if let pressure = weather.details?.pressure {
          self.pressure.value = "\(pressure.removeZerosFromEnd()) mm Hg"
        }
        let windDirection = weather.wind?.direction?.compassDirection ?? ""
        let windSpeed = weather.wind?.speed?.removeZerosFromEnd() ?? ""
        self.wind.value = "\(windDirection) \(windSpeed) m/s"
        self.weatherDescription.value = weather.info?.first?.description?.capitalized
        
        if let icon = weather.info?.first?.icon {
        self.weatherIcon.value = URL(string: "\(Constants.apiIconsUrl)/img/wn/\(icon)@2x.png")
        }
        if let id = weather.info?.first?.id {
          self.weatherImage.value = self.weatherImages[id]
        }
      case .failure(let error):
        self.apiError.value = error
      }
    }
  }
  
  func goBack() {
    delegate?.weatherViewModelDidFinish(self)
  }
}
