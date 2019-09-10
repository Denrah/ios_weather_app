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
    mapViewModel.delegate = self
    let mapViewController = MapViewController(viewModel: mapViewModel)
    rootViewController.setViewControllers([mapViewController], animated: false)
  }
}

extension MapCoordinator: WeatherCoordinatorDelegate {
  func didFinish(from coordinator: WeatherCoordinator) {
    removeChildCoordinator(coordinator)
  }
}

// MARK: - transitions between scenes

extension MapCoordinator: MapViewModelDelegate {
  func mapViewModel(_ viewModel: MapViewModel, didRequestToShowWeatherFor city: String) {
    let weatherCoordinator = WeatherCoordinator(rootViewController: self.rootViewController, city: city)
    weatherCoordinator.delegate = self
    addChildCoordinator(weatherCoordinator)
    weatherCoordinator.start()
  }
}
