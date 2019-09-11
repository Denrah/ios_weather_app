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
  @IBOutlet private weak var temperatureLabelTopConstraint: NSLayoutConstraint!
  @IBOutlet private weak var weatherIconImageViewHeightConstraint: NSLayoutConstraint!
  
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
    viewModel.apiError.bind = { [weak self] in
      guard let self = self else { return }
      guard let error = $0 else { return }
      let alert = UIAlertController(title: WeatherConstants.errorAlertTitle,
                                    message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: WeatherConstants.errorAlertDismissButtonText, style: .cancel) { _ in
        self.navigationController?.popViewController(animated: true)
        self.viewModel.goBack()
      })
      SVProgressHUD.dismiss()
      self.present(alert, animated: true, completion: nil)
    }
    
    viewModel.weatherState.bind = { [weak self] state in
      guard let self = self else { return }
      guard let state = state else { return }
      
      self.temperatureLabel.text = state.temperature
      self.humidityLabel.text = state.humidity
      self.windLabel.text = state.wind
      self.pressureLabel.text = state.pressure
      self.descriptionLabel.text = state.weathrDescription
      self.weatherImageView.image = state.weatherImage
      self.weatherIconImageView.kf.setImage(with: state.weathrIcon)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UIScreen.main.bounds.height < 600 {
      temperatureLabel.font = temperatureLabel.font.withSize(60)
      temperatureLabelTopConstraint.constant = 0
      weatherIconImageViewHeightConstraint.constant = 60
    }
    
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
