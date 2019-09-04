//
//  MapCoordinator.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit

class MapCoordinator: Coordinator {
    let rootViewController: UINavigationController
    
    lazy var mapViewModel: MapViewModel = {
        let viewModel = MapViewModel()
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
       let mapViewController = MapViewController(nibName: Constants.MapScreenName, bundle: nil)
        mapViewController.viewModel = mapViewModel
        rootViewController.setViewControllers([mapViewController], animated: false)
    }
}

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
