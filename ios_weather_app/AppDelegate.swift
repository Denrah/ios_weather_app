//
//  AppDelegate.swift
//  ios_weather_app
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  lazy var appCoordinator: AppCoordinator = {
    return AppCoordinator(window: self.window)
  }()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    appCoordinator = AppCoordinator(window: window)
    appCoordinator.start()
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    
  }
  
}
