//
//  OpenWeatherAPI.swift
//  test_native
//
//  Created by ihor on 11.11.2021.
//

import Foundation
import Combine
import MapKit

class OpenWeatherAPI{
    static let shared = OpenWeatherAPI()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let onecallURL = "https://api.openweathermap.org/data/2.5/onecall"
    private let apiKey = "eb54b9382c6e2f6360a09cbba94b825b"
    
    private func createUrlCurrentCoordinate(coordinate: CLLocationCoordinate2D) -> URL?{
        let queryURL = URL(string: baseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else{return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "units", value: "metric")
        ]
        print(urlComponents.url as Any)
        return urlComponents.url
    }

    private func createUrlCityName(city: String) -> URL?{
        let queryURL = URL(string: baseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else{return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return urlComponents.url
    }

    private func createUrlCityCoordinate(coordinate: CLLocationCoordinate2D) -> URL?{
        let queryURL = URL(string: onecallURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else{return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "exclude", value: "minutely"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "ru")
        ]
        return urlComponents.url
    }

    func getCityNameWeather(for city: String) -> AnyPublisher<CityWeatherData, Never>{
        guard let url = createUrlCityName(city: city) else {
            return Just(CityWeatherData.placeholder)
                .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for: url)
                .map{
                    return $0.data
                }
                .decode(type: CityWeatherData.self, decoder: JSONDecoder())
                .catch{erro in Just(CityWeatherData.placeholder)}
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }

    func getCoordinateWeather(for coordinate: CLLocationCoordinate2D) -> AnyPublisher<CityWeatherSevenDays, Never>{
        guard let url = createUrlCityCoordinate(coordinate: coordinate) else {
            return Just(CityWeatherSevenDays.placeholder)
                .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for: url)
                .map{
                    return $0.data
                }
                .decode(type: CityWeatherSevenDays.self, decoder: JSONDecoder())
                .mapError({
                 (error) -> Error in
                    print(error)
                    return error
                })
                .catch({erro -> Just<CityWeatherSevenDays> in
                    print(erro.localizedDescription)
                    return Just(CityWeatherSevenDays.placeholder)
                })
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }

    func getCoordinateCurrentWeather(for coordinate: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeather, Never>{
        guard let url = createUrlCurrentCoordinate(coordinate: coordinate) else {
            return Just(CurrentWeather.placeholder)
                .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for: url)
                .map{
                    let d = String(bytes: $0.data, encoding: String.Encoding.utf8)
                    print(d as Any)
                    return $0.data
                }
                .decode(type: CurrentWeather.self, decoder: JSONDecoder())
            .mapError({
             (error) -> Error in
                print(error)
                return error
            })
                .catch({erro -> Just<CurrentWeather> in
                    print(erro.localizedDescription)
                    return Just(CurrentWeather.placeholder)
                })
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }
}
