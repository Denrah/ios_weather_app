//
//  MapCoordinator.swift
//  ios_weather_app
//

import UIKit

class MapCoordinator: Coordinator {
  let rootViewController: UINavigationController
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let geocodingService = GeocodingService()
    let mapViewModel = MapViewModel(geocodingService: geocodingService)
    mapViewModel.coordinatorDelegate = self
    let mapViewController = MapViewController(viewModel: mapViewModel)
    rootViewController.setViewControllers([mapViewController], animated: false)
  }
}

// MARK: - transitions between scenes

extension MapCoordinator {
  func goToWeather(city: String) {
    let weatherCoordinator = WeatherCoordinator(rootViewController: self.rootViewController, city: city)
    weatherCoordinator.delegate = self
    addChildCoordinator(weatherCoordinator)
    weatherCoordinator.start()
  }
}

extension MapCoordinator: MapCoordinatorDelegate {
  func didFinish(from coordinator: WeatherCoordinator) {
    removeChildCoordinator(coordinator)
  }
}
