//
//  CityWeatherData.swift
//  test_native
//
//  Created by ihor on 11.11.2021.
//
import Foundation

// MARK: - CityWeather
struct CityWeatherData: Codable {
    let coord: Coord?
    let weather: [WeatherD]?
    let base: String?
    let main: MainD?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    
    static var placeholder: Self{
        return CityWeatherData(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: nil, cod: nil)
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct MainD: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct WeatherD: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
