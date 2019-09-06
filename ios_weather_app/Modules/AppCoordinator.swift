//
//  AppCoordinator.swift
//  ios_weather_app
//

import UIKit

class AppCoordinator: Coordinator {
  // MARK: - Properties
  let window: UIWindow?
  
  let rootViewController: UINavigationController = {
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
    
    let mapCoordinator = MapCoordinator(rootViewController: rootViewController)
    self.addChildCoordinator(mapCoordinator)
    mapCoordinator.start()
    
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
  
  override func finish() {
  }
}
