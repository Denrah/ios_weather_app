//
//  WeatherViewController.swift
//  ios_weather_app
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher

class WeatherViewController: UIViewController {
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var humidityLabel: UILabel!
  @IBOutlet private weak var windLabel: UILabel!
  @IBOutlet private weak var pressureLabel: UILabel!
  @IBOutlet private weak var weatherIconImageView: UIImageView!
  @IBOutlet private weak var weatherImageView: UIImageView!
  @IBOutlet private weak var degreesIconView: UIView!
  
  private enum WeatherConstants {
    static let errorAlertTitle = "Error!"
    static let errorAlertDismissButtonText = "OK"
  }
  
  let viewModel: WeatherViewModel
  
  init(viewModel: WeatherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.navigationItem.title = viewModel.city.value
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    viewModel.goBack()
  }
  
  // MARK: - Scene setup
  
  private func bindToViewModel() {
    bindWeatherValues()
    bindImages()
    
    viewModel.apiError.bind = { [weak self] in
      guard let self = self else { return }
      guard let error = $0 else { return }
      let alert = UIAlertController(title: WeatherConstants.errorAlertTitle,
                                    message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: WeatherConstants.errorAlertDismissButtonText, style: .cancel) { _ in
        self.navigationController?.popViewController(animated: true)
        self.viewModel.goBack()
      })
      self.present(alert, animated: true, completion: nil)
    }
    
    viewModel.loadingInProgress.bind = {
      guard let loadingInProgress = $0 else { return }
      if loadingInProgress {
        SVProgressHUD.show()
      } else {
        SVProgressHUD.dismiss()
      }
    }
  }
  
  private func bindWeatherValues() {
    viewModel.temperature.bind = { [weak self] temperature in
      temperature.flatMap { self?.temperatureLabel.text = $0 }
    }
    
    viewModel.humidity.bind = { [weak self] humidity in
      humidity.flatMap { self?.humidityLabel.text = $0 }
    }
    
    viewModel.wind.bind = { [weak self] wind in
      wind.flatMap { self?.windLabel.text = $0 }
    }
    
    viewModel.pressure.bind = { [weak self] pressure in
      pressure.flatMap { self?.pressureLabel.text = $0 }
    }
    
    viewModel.weatherDescription.bind = { [weak self] weatherDescription in
      weatherDescription.flatMap { self?.descriptionLabel.text = $0 }
    }
  }
  
  private func bindImages() {
    viewModel.weatherImage.bind = { [weak self] weatherImage in
      weatherImage.flatMap { self?.weatherImageView.image = $0 }
    }
    
    viewModel.weatherIcon.bind = { [weak self] weatherIcon in
      _ = weatherIcon.flatMap { self?.weatherIconImageView.kf.setImage(with: $0) }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    degreesIconView.layer.borderWidth = 3
    degreesIconView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
    
    bindToViewModel()
    configureNavigationBar()
    viewModel.getWeather()
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Values formatting helper
  
  private func unwrapWeatherValue(weatherValue: Double?) -> String {
    if let weatherValue = weatherValue {
      return String(weatherValue.removeZerosFromEnd())
    } else {
      return "-"
    }
  }
}
