//
//  MapViewModel.swift
//  ios_weather_app
//

import Foundation
import MapKit

class MapViewModel {
  weak var coordinatorDelegate: MapCoordinator?
  
  let selectedCity = Dynamic<String>(nil)
  let selectedCoordinate = Dynamic<CLLocationCoordinate2D>(Constants.MapInitialCoordinate)
  let geocodingInProgress = Dynamic<Bool>(false)
  let popupIsOpened = Dynamic<Bool>(false)
  
  private let geocodingService: GeocodingService
  
  init(geocodingService: GeocodingService) {
    self.geocodingService = geocodingService
  }
  
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
    geocodingInProgress.value = true
    geocodingService.coordinatesFromCity(city: city) { result in
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
  
  func updateCoordinate(coordinate: CLLocationCoordinate2D) {
    selectedCoordinate.value = coordinate
  }
  
  func goToWeather() {
    guard let city = selectedCity.value else {return}
    coordinatorDelegate?.goToWeather(city: city)
  }
}

extension MapViewModel: MapViewModelDelegate {
  func onPopupCloseButton() {
    popupIsOpened.value = false
  }
  
  func onPopupMainButton() {
    goToWeather()
  }
}
