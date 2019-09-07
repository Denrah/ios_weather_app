//
//  MapPopupViewModel.swift
//  ios_weather_app
//

import Foundation

class MapPopupViewModel {
  weak var parentDelegate: MapViewModelDelegate?
  
  let title = Dynamic<String>(nil)
  let subtitle = Dynamic<String>(nil)
  
  init(delegate: MapViewModelDelegate) {
    parentDelegate = delegate
  }
  
  func onCloseButton() {
    parentDelegate?.onPopupCloseButton()
  }
  
  func onMainButton() {
    parentDelegate?.onPopupMainButton()
  }
}
