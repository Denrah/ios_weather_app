//
//  MapPopupViewModel.swift
//  ios_weather_app
//

import Foundation

protocol MapPopupViewModelDelegate: class {
  func mapPopupViewModelDidTapClose(_ viewModel: MapPopupViewModel)
  func mapPopupViewModelDidTapShowWeather(_ viewModel: MapPopupViewModel)
}

class MapPopupViewModel {
  weak var delegate: MapPopupViewModelDelegate?
  
  let title = Dynamic<String>(nil)
  let subtitle = Dynamic<String>(nil)
  
  init(delegate: MapPopupViewModelDelegate) {
    self.delegate = delegate
  }
  
  func onCloseButton() {
    delegate?.mapPopupViewModelDidTapClose(self)
  }
  
  func onShowWeatherButton() {
    delegate?.mapPopupViewModelDidTapShowWeather(self)
  }
}
