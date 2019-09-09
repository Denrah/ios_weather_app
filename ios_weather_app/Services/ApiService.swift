//
//  ApiService.swift
//  ios_weather_app
//

import Alamofire

enum ApiErrors: Error {
  case badCityError
}

extension ApiErrors: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badCityError:
      return "Can't get weather for current city"
    }
  }
}

class ApiService {
  func getWeatherByCity(city: String, completion: @escaping (Swift.Result<Weather?, Error>) -> Void) {
    guard let ecnodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      completion(Swift.Result.failure(ApiErrors.badCityError))
      return
    }
    Alamofire.request(Constants.apiUrl
      + "/data/2.5/weather?q="
      + ecnodedCity
      + "&units=metric&APPID="
      + Api.key).responseData { response in
        
        switch response.result {
        case .success(let data):          
          let decoder = JSONDecoder()
          
          do {
            let weather = try decoder.decode(Weather.self, from: data)
            completion(Swift.Result.success(weather))
            
          } catch let error {
            completion(Swift.Result.failure(error))
            return
          }
        case .failure(let error):
          completion(Swift.Result.failure(error))
        }
    }
  }
}
