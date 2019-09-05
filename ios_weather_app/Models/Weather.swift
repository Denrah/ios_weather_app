struct WeatherInfo: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct WeatherDetails: Codable {
    var temp: Double
    var pressure: Double
    var humidity: Double
}

struct WeatherWind: Codable {
    var speed: Double
    var deg: Double
}

struct Weather: Codable {
    var weather: [WeatherInfo]
    var main: WeatherDetails
    var wind: WeatherWind
    var name: String
}
