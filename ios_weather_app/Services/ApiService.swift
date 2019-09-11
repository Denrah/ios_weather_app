//
//  ApiService.swift
//  ios_weather_app
//

import Alamofire

enum ApiErrors: Error {
  case badCityError
  case cityNotFound
  case serverError
}

extension ApiErrors: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badCityError:
      return "Can't get weather for current city"
    case .cityNotFound:
      return "City not found"
    case .serverError:
      return "Ooups, there is some problems on the server side! Try again later."
    }
  }
}

class ApiService {
  private func baseRequest<T>(ofType: T.Type, method: HTTPMethod, url: String,
                              parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default,
                              completion: @escaping (Swift.Result<T, Error>) -> Void) where T: Decodable {
    Alamofire.request(url, method: method,
                      parameters: parameters, encoding: encoding, headers: nil).responseData { response in
      switch response.result {
      case .success(let data):
        guard let statusCode = response.response?.statusCode else {
          completion(.failure(ApiErrors.serverError))
          return
        }
        guard case 200...206 = statusCode else {
          completion(.failure(self.handleError(statusCode: response.response?.statusCode)))
          return
        }
        
        let decoder = JSONDecoder()
        
        do {
          let decodedData = try decoder.decode(T.self, from: data)
          completion(Swift.Result.success(decodedData))
          
        } catch let error {
          completion(Swift.Result.failure(error))
          return
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getWeatherByCity(city: String, completion: @escaping (Swift.Result<Weather, Error>) -> Void) {
    let url = Constants.apiUrl + "/data/2.5/weather"
    
    let params = [
      "q": city,
      "units": "metric",
      "APPID": Api.key
    ]
    
    baseRequest(ofType: Weather.self, method: HTTPMethod.get,
                url: url, parameters: params, encoding: URLEncoding.default) { result in
      completion(result)
    }
  }
  
  private func handleError(statusCode: Int?) -> Error {
    guard let statusCode = statusCode else {
      return ApiErrors.badCityError
    }
    
    switch statusCode {
    case 400...499:
      return ApiErrors.cityNotFound
    case 500...526:
      return ApiErrors.serverError
    default:
      return ApiErrors.badCityError
    }
  }
}
