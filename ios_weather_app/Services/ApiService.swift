//
//  ApiService.swift
//  ios_weather_app
//

import Alamofire

class ApiService {
  func getWeatherByCity(city: String, completion: @escaping (Weather?) -> Void) {
    guard let ecnodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      completion(nil)
      return
    }
    Alamofire.request(Constants.apiUrl
      + "/data/2.5/weather?q="
      + ecnodedCity
      + "&units=metric&APPID="
      + Api.key).responseData { response in
        guard let data = response.data else {
          return
        }
        
        let decoder = JSONDecoder()
        
        do {
          let weather = try decoder.decode(Weather.self, from: data)
          completion(weather)
          
        } catch let error {
          print(error)
          completion(nil)
          return
        }
    }
  }
}
