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
    
    init() {
        
    }
    
    func geocodeCityFromCoordinate(coordinate: CLLocationCoordinate2D) {
        GeocodingService.cityFromCoordinates(coordinate: coordinate) { (placemarks, error) in
            guard error == nil else {
                self.selectedCity.value = nil
                return
            }

            self.selectedCity.value = placemarks?.first?.locality
        }
    }
    
}
