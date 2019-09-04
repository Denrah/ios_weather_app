//
//  MapViewModel.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel {
    weak var coordinatorDelegate: MapCoordinator?
    
    var selectedCity = Dynamic<String>(nil)
    var selectedCoordinate = Dynamic<CLLocationCoordinate2D>(Constants.MapInitialCoordinate)
    var geocodingInProgress = Dynamic<Bool>(false)
    
    init() {
        
    }
    
    func geocodeCityFromCoordinate(coordinate: CLLocationCoordinate2D) {
        geocodingInProgress.value = true
        GeocodingService.cityFromCoordinates(coordinate: coordinate) { placemarks, error in
            self.geocodingInProgress.value = false
            
            guard error == nil else {
                self.selectedCity.value = nil
                return
            }

            self.selectedCity.value = placemarks?.first?.locality
        }
    }
    
    func geocodeCoordinateFromCity(city: String) {
        geocodingInProgress.value = true
        GeocodingService.coordinatesFromCity(city: city) { (placemarks, error) in
            self.geocodingInProgress.value = false
            
            guard error == nil else {
                self.selectedCity.value = nil
                return
            }
            
            self.selectedCity.value = placemarks?.first?.locality
            self.selectedCoordinate.value = placemarks?.first?.location?.coordinate
        }
    }
    
    func updateCoordinate(coordinate: CLLocationCoordinate2D) {
        selectedCoordinate.value = coordinate
    }
    
}
