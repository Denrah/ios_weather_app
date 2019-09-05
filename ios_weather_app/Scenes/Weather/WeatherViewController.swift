//
//  WeatherViewController.swift
//  ios_weather_app
//
//  Created by iOS Intern on 04/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
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
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var viewModel: WeatherViewModel! {
        didSet {
            self.viewModel.city.bind = {[weak self] in
                guard let self = self else {return}
                guard let city = $0 else {return}
                self.navigationItem.title = city
            }
            
            self.viewModel.weather.bind = {[weak self] in
                guard let self = self else {return}
                guard let weather = $0 else {return}
                
                if let icon = weather.weather.first?.icon {
                    let iconUrl = URL(string: Constants.apiIconsUrl + "/img/wn/\(icon)@2x.png");
                    self.weatherIcon.kf.setImage(with: iconUrl)
                }
                
                self.tempLabel.text = "\(Int(weather.main.temp))"
                self.statusLabel.text = "\(weather.weather.first?.description.capitalized ?? "-")"
                self.humidityValueLabel.text = "\(weather.main.humidity)%"
                self.windValueLabel.text = "\(weather.wind.speed) m/s"
                self.pressureValueLabel.text = "\(weather.main.pressure)"
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        
        viewModel.getWeather()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
