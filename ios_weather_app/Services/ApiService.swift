//
//  ApiService.swift
//  ios_weather_app
//
//  Created by iOS Intern on 05/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import Alamofire

class ApiService {
    static func getWeatherByCity(city: String, completion: @escaping (Weather?) -> Void) {
        Alamofire.request(Constants.apiUrl + "/data/2.5/weather?q=" + city + "&units=metric&APPID=" + Api.key).responseData { (response) in
            guard let data = response.data else {
                completion(nil)
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
