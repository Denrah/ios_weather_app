//
//  MapViewModel.swift
//  ios_weather_app
//

import Foundation
import MapKit

protocol MapViewModelDelegate: class {
  func mapViewModel(_ viewModel: MapViewModel, didRequestToShowWeatherFor city: String)
}

class MapViewModel {
  weak var delegate: MapViewModelDelegate?
  
  // MARK: - ViewModel values
  
  let selectedCity = Dynamic<String>(nil)
  let selectedCoordinate = Dynamic<CLLocationCoordinate2D>(Constants.mapInitialCoordinate)
  let geocodingInProgress = Dynamic<Bool>(false)
  let popupIsOpened = Dynamic<Bool>(false)
  
  private let geocodingService: GeocodingService
  private var searchDelayDispatch: DispatchWorkItem?
  
  init(geocodingService: GeocodingService) {
    self.geocodingService = geocodingService
  }
  
  // MARK: - Geocoding methods
  
  func geocodeCityFromCoordinate(coordinate: CLLocationCoordinate2D) {
    geocodingInProgress.value = true
    geocodingService.cityFromCoordinates(coordinate: coordinate) { result in
      self.geocodingInProgress.value = false
      
      switch result {
      case .success(let placemark):
        self.selectedCity.value = placemark?.locality
      case .failure(let error):
        print(error)
        self.selectedCity.value = nil
      }
    }
  }
  
  func geocodeCoordinateFromCity(city: String) {
    searchDelayDispatch?.cancel()
    
    searchDelayDispatch = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      
      self.geocodingInProgress.value = true
      self.geocodingService.coordinatesFromCity(city: city) { result in
        self.geocodingInProgress.value = false
        
        switch result {
        case .success(let placemark):
          self.selectedCity.value = placemark?.locality
          self.selectedCoordinate.value = placemark?.location?.coordinate
        case .failure(let error):
          print(error)
          self.selectedCity.value = nil
        }
      }
    }
    
    if let searchDelayDispatch = searchDelayDispatch {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: searchDelayDispatch)
    }
  }
  
  func updateCoordinate(coordinate: CLLocationCoordinate2D) {
    selectedCoordinate.value = coordinate
  }
  
  // MARK: - Moving between screens
  
  private func goToWeather() {
    guard let city = selectedCity.value else { return }
    delegate?.mapViewModel(self, didRequestToShowWeatherFor: city)
  }
}

// MARK: - Popup events

extension MapViewModel: MapPopupViewModelDelegate {
  func mapPopupViewModelDidTapClose(_ viewModel: MapPopupViewModel) {
    popupIsOpened.value = false
  }
  
  func mapPopupViewModelDidTapShowWeather(_ viewModel: MapPopupViewModel) {
    goToWeather()
  }
}
