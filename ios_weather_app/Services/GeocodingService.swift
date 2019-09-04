//
//  GeocodingService.swift
//  ios_weather_app
//
//  Created by iOS Intern on 04/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import MapKit

class GeocodingService {
    static func cityFromCoordinates(coordinate: CLLocationCoordinate2D, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation( CLLocation(latitude: coordinate.latitude,
                                                        longitude: coordinate.longitude)) { placemarks, error in
            completion(placemarks, error)
        }
    }
    
    static func coordinatesFromCity(city: String, completion: @escaping ([CLPlacemark]?, Error?) -> Void) {
        CLGeocoder().geocodeAddressString(city) { (placemarks, error) in
            completion(placemarks, error)
        }
    }
}
