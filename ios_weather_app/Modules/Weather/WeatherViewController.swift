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
      let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
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
    viewModel.temperature.bind = { [weak self] in
      guard let self = self else { return }
      guard let temperature = $0 else { return }
      self.temperatureLabel.text = temperature
    }
    
    viewModel.humidity.bind = { [weak self] in
      guard let self = self else { return }
      guard let humidity = $0 else { return }
      self.humidityLabel.text = humidity
    }
    
    viewModel.wind.bind = { [weak self] in
      guard let self = self else { return }
      guard let wind = $0 else { return }
      self.windLabel.text = wind
    }
    
    viewModel.pressure.bind = { [weak self] in
      guard let self = self else { return }
      guard let pressure = $0 else { return }
      self.pressureLabel.text = pressure
    }
    
    viewModel.weatherDescription.bind = { [weak self] in
      guard let self = self else { return }
      guard let weatherDescription = $0 else { return }
      self.descriptionLabel.text = weatherDescription.capitalized
    }
  }
  
  private func bindImages() {
    viewModel.weatherImage.bind = { [weak self] in
      guard let self = self else { return }
      guard let weatherImage = $0 else { return }
      self.weatherImageView.image = weatherImage
    }
    
    viewModel.weatherIcon.bind = { [weak self] in
      guard let self = self else { return }
      guard let weatherIcon = $0 else { return }
      let iconUrl = URL(string: "\(Constants.apiIconsUrl)/img/wn/\(weatherIcon)@2x.png")
      self.weatherIconImageView.kf.setImage(with: iconUrl)
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
