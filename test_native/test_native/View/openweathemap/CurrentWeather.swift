// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let currentWeather = try? newJSONDecoder().decode(CurrentWeather.self, from: jsonData)

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: MainC?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
    let dt: Int?
    let sys: SysC?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    
    static var placeholder: Self{
        return CurrentWeather(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, clouds: nil, rain: nil, snow: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: nil, cod: nil)
    }

}

// MARK: - Clouds
struct CloudsC: Codable {
    let all: Int
}

// MARK: - Coord
struct CoordC: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct MainC: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct SysC: Codable {
    let type: Int?
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct WeatherC: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct WindC: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Rain: Codable {
    let _1h: Double?
    let _3h: Double?
    enum CodingKeys: String, CodingKey{
        case _1h = "1h"
        case _3h = "3h"
    }
}
struct Snow: Codable{
    let _1h: Double?
    let _3h: Double?
    enum CodingKeys: String, CodingKey{
        case _1h = "1h"
        case _3h = "3h"
    }
}
