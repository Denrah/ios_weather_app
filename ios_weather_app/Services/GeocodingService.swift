//
//  GeocodingService.swift
//  ios_weather_app
//

import MapKit

class GeocodingService {
  func cityFromCoordinates(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
    CLGeocoder().reverseGeocodeLocation( CLLocation(latitude: coordinate.latitude,
                                                    longitude: coordinate.longitude)) { placemarks, error in
                                                      if let error = error {
                                                        completion(.failure(error))
                                                        return
                                                      }
                                                      
                                                      completion(.success(placemarks?.first))
    }
  }
  
  func coordinatesFromCity(city: String, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
    CLGeocoder().geocodeAddressString(city) { placemarks, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      completion(.success(placemarks?.first))
    }
  }
}
