//
//  MapPopupViewModel.swift
//  ios_weather_app
//

import Foundation

protocol MapPopupViewModelDelegate: class {
  func mapPopupViewModelOnCloseButton(_ viewModel: MapPopupViewModel)
  func mapPopupViewModelOnMainButton(_ viewModel: MapPopupViewModel)
}

class MapPopupViewModel {
  weak var delegate: MapPopupViewModelDelegate?
  
  let title = Dynamic<String>(nil)
  let subtitle = Dynamic<String>(nil)
  
  init(delegate: MapPopupViewModelDelegate) {
    self.delegate = delegate
  }
  
  func onCloseButton() {
    delegate?.mapPopupViewModelOnCloseButton(self)
  }
  
  func onMainButton() {
    delegate?.mapPopupViewModelOnMainButton(self)
  }
}
