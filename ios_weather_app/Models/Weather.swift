//
//  Weather.swift
//  ios_weather_app
//

struct WeatherInfo: Codable {
  let id: Int?
  let description: String?
  let icon: String?
  
  enum CodingKeys: String, CodingKey {
    case description
    case icon
    case id
  }
}

struct WeatherDetails: Codable {
  let temperature: Double?
  let pressure: Double?
  let humidity: Double?
  
  enum CodingKeys: String, CodingKey {
    case temperature = "temp"
    case pressure
    case humidity
  }
}

struct WeatherWind: Codable {
  let speed: Double?
  let direction: Double?
  
  enum CodingKeys: String, CodingKey {
    case speed
    case direction = "deg"
  }
}

struct Weather: Codable {
  let info: [WeatherInfo]?
  let details: WeatherDetails?
  let wind: WeatherWind?
  
  enum CodingKeys: String, CodingKey {
    case info = "weather"
    case details = "main"
    case wind
  }
}
