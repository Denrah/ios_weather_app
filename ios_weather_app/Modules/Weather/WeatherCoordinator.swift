//
//  WeatherCoordinator.swift
//  ios_weather_app
//

import UIKit

class WeatherCoordinator: Coordinator {
  let rootViewController: UINavigationController
  weak var delegate: MapCoordinatorDelegate?
  let city: String
  
  init(rootViewController: UINavigationController, city: String) {
    self.rootViewController = rootViewController
    self.city = city
  }
  
  override func start() {
    let apiService = ApiService()
    let weatherViewModel = WeatherViewModel(apiService: apiService, city: city)
    weatherViewModel.delegate = self
    let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
    rootViewController.pushViewController(weatherViewController, animated: true)
  }
  
  override func finish() {
    delegate?.didFinish(from: self)
  }
}

extension WeatherCoordinator: WeatherViewModelDelegate {
  func weatherViewModelDidFinish(_ viewModel: WeatherViewModel) {
    finish()
  }
}
