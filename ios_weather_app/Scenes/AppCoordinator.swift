//
//  AppCoordinator.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    override func finish() {
        
    }
    
}
