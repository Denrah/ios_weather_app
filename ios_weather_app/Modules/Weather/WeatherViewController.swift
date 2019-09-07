//
//  WeatherViewController.swift
//  ios_weather_app
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher

class WeatherViewController: UIViewController {
  @IBOutlet private weak var tempLabel: UILabel!
  @IBOutlet private weak var statusLabel: UILabel!
  @IBOutlet private weak var humidityValueLabel: UILabel!
  @IBOutlet private weak var windValueLabel: UILabel!
  @IBOutlet private weak var pressureValueLabel: UILabel!
  @IBOutlet private weak var weatherIcon: UIImageView!
  @IBOutlet private weak var weatherImage: UIImageView!
  @IBOutlet private weak var degreesIcon: UIView!
  
  private let weatherImages: [String: UIImage] = [
    "01": #imageLiteral(resourceName: "clearsky"),
    "02": #imageLiteral(resourceName: "fewclouds"),
    "03": #imageLiteral(resourceName: "scatteredclouds"),
    "04": #imageLiteral(resourceName: "brokenclouds"),
    "09": #imageLiteral(resourceName: "showerrain"),
    "10": #imageLiteral(resourceName: "rain"),
    "11": #imageLiteral(resourceName: "thunderstorm"),
    "13": #imageLiteral(resourceName: "snow"),
    "50": #imageLiteral(resourceName: "mist")
  ]
  
  let viewModel: WeatherViewModel
  
  init(viewModel: WeatherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.navigationItem.title = viewModel.city.value
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Scene setup
  
  private func bindToViewModel() {
    self.viewModel.weather.bind = {[weak self] in
      guard let self = self else {return}
      guard let weather = $0 else {
        let alert = UIAlertController(title: "Error!",
                                      message: "Network error has occurred! Try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
          self.viewModel.goBack()
        })
        self.present(alert, animated: true, completion: nil)
        return
      }
      
      self.updateWeatherScreen(weather: weather)
    }
    self.viewModel.loadingInProgress.bind = {
      guard let value = $0 else {return}
      if value {
        SVProgressHUD.show()
      } else {
        SVProgressHUD.dismiss()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    degreesIcon.layer.borderWidth = 3
    degreesIcon.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
    
    bindToViewModel()
    configureNavigationBar()
    viewModel.getWeather()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if self.isMovingFromParent {
      viewModel.goBack()
    }
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  private func updateWeatherScreen(weather: Weather) {
    if let icon = weather.weather.first?.icon {
      let iconUrl = URL(string: Constants.apiIconsUrl + "/img/wn/\(icon)@2x.png")
      self.weatherIcon.kf.setImage(with: iconUrl)
      self.weatherImage.image = self.weatherImages[String(icon.prefix(icon.count - 1))]
    }
    
    let deg = weather.wind.deg ?? 0
    self.humidityValueLabel.text = self.unwrapWeatherValue(value: weather.main.humidity) + "%"
    self.windValueLabel.text = deg.compassDirection + " " + self.unwrapWeatherValue(value: weather.wind.speed) + " m/s"
    self.pressureValueLabel.text = self.unwrapWeatherValue(value: weather.main.pressure) + " mm Hg"
    
    if let description = weather.weather.first?.description {
      self.statusLabel.text = "\(description.capitalized)"
    } else {
      self.statusLabel.text = "-"
    }
    
    if let temp = weather.main.temp {
      self.tempLabel.text = "\(Int(temp))"
    } else {
      self.statusLabel.text = "--"
    }
  }
  
  // MARK: - Values formatting helper
  
  private func unwrapWeatherValue(value: Double?) -> String {
    if let value = value {
      return String(value.removeZerosFromEnd())
    } else {
      return "-"
    }
  }
}
