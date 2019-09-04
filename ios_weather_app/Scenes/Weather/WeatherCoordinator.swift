//
//  WeatherCoordinator.swift
//  ios_weather_app
//
//  Created by iOS Intern on 04/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit

class WeatherCoordinator: Coordinator {
    let rootViewController: UINavigationController
    weak var delegate: MapCoordinatorDelegate?
    var city: String
    
    init(rootViewController: UINavigationController, city: String) {
        self.rootViewController = rootViewController
        self.city = city
    }
    
    override func start() {
        let weatherViewController = WeatherViewController(nibName: Constants.WeatherScreenName, bundle: nil)
        rootViewController.pushViewController(weatherViewController, animated: true)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
}
