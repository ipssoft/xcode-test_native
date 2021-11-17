//
//  DataModel.swift
//  test_native
//
//  Created by ihor on 28.10.2021.
//

import SwiftUI
import MapKit
import Combine

enum TypeWeather: String {
    case dayBright  = "ic_white_day_bright"
    case dayCloudy  = "ic_white_day_cloudy"
    case dayRain    = "ic_white_day_rain"
    case dayShower  = "ic_white_day_shower"
    case dayThunder = "ic_white_day_thunder"
    case nigthBright    = "ic_white_night_bright"
    case nigthCloudy    = "ic_white_night_cloudy"
    case nigthRain      = "ic_white_night_rain"
    case nigthShower    = "ic_white_night_shower"
    case nigthThunder   = "ic_white_night_thunder"
}

enum WindDirect: String, CaseIterable{
    case windE = "icon_wind_e"
    case windN = "icon_wind_n"
    case windNE = "icon_wind_ne"
    case windS = "icon_wind_s"
    case windSE = "icon_wind_se"
    case windW = "icon_wind_w"
    case windWN = "icon_wind_wn"
    case windWS = "icon_wind_ws"
}

class Hour: ObservableObject {
    @Published var hour: Int = 0
    @Published var temp: Int = 17
    @Published var typeWeather: TypeWeather = .dayBright
    init(hour: Int){
        self.hour = hour
    }
}

class Day: ObservableObject{
    let DayName: [String] = ["ВС", "ПН", "ВТ", "СР", "ЧТ", "ПT", "СБ"]
    
    @Published var tempDay: Int = 27
    @Published var tempNight: Int = 19
    @Published var humidity: Int = 33
    @Published var windSpeed: Int = 5
    @Published var windDirect: WindDirect = .windS
    @Published var typeWeather: TypeWeather = .dayBright
    @Published var dayOfWeek: Int = 0
}

class Hours: ObservableObject{

    @Published var hours: [Hour] = []

    func createHours(c: Int = 24){
        self.hours.removeAll()
        for i in 0..<c{
            self.hours.append(Hour(hour: i))
        }
    }
    
    init(countHours: Int){
        if countHours > 0{
            self.createHours(c: countHours)
        }
    }
}

class Days: ObservableObject{
    @Published var days: [Day] = []
    @Published var count: Int = 0
    func createDays(c: Int){
        self.days.removeAll()
        for _ in 0..<c{
            self.days.append(Day())
        }
        self.count = c
    }
    init(){
        createDays(c: 8)
        self.count = 8
    }
}

struct DataModel: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

class City: ObservableObject{
    @Published var dayName: String
    @Published var localName: String
    @Published var coordinate: CLLocationCoordinate2D
    @Published var region: MKCoordinateRegion
    @Published var currentDay: Day
    @Published var days: Days
    @Published var hours: Hours
    @Published var currentWeather = CityWeatherData.placeholder
    @Published var weatherSevenDays = CityWeatherSevenDays.placeholder
    @Published var currentCityWeather = CurrentWeather.placeholder
    
    private var cancellableSet: Set<AnyCancellable> = []
    init(){

        let defaults = UserDefaults.standard
        self.currentDay = Day()
        self.days = Days()
        self.hours = Hours(countHours: 24)
        self.dayName = ""
        self.localName = "Запорожье"
        self.coordinate = CLLocationCoordinate2D(latitude: 47.82448313086755, longitude: 35.20050000000009)
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 47.4922, longitude: 35.1125
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.1, longitudeDelta: 1
            )
        )
        if defaults.object(forKey: "city_lat") != nil{
            self.region.center.latitude = defaults.double(forKey: "city_lat")
            self.region.center.longitude = defaults.double(forKey: "city_long")
            self.coordinate.latitude = self.region.center.latitude
            self.coordinate.longitude = self.region.center.longitude
        }
        if defaults.object(forKey: "city_name") != nil{
            self.localName = defaults.string(forKey: "city_name")!
        }

        $localName
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: {value in
                    print(value as Any)
                    let defaults = UserDefaults.standard
                    defaults.setValue(value, forKey: "city_name")
                }
            )
            .store(in: &self.cancellableSet)

        $coordinate
            .flatMap{ (coordinte: CLLocationCoordinate2D) -> AnyPublisher<CityWeatherSevenDays, Never> in
                OpenWeatherAPI.shared.getCoordinateWeather(for: coordinte)
            }
            .assign(to: \.weatherSevenDays, on: self)
            .store(in: &self.cancellableSet)

        $coordinate
            .flatMap{ (coordinte: CLLocationCoordinate2D) -> AnyPublisher<CurrentWeather, Never> in
                OpenWeatherAPI.shared.getCoordinateCurrentWeather(for: coordinte)
            }
            .assign(to: \.currentCityWeather, on: self)
            .store(in: &self.cancellableSet)

        $currentWeather
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: {value in
                    print(value.main as Any)
                }
            )
            .store(in: &self.cancellableSet)

        $weatherSevenDays
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: {value in
                    print(value.current as Any)
                    self.setSevenDays(data: value)
                    self.setHourly(data: value)
                }
            )
            .store(in: &self.cancellableSet)
        
        $currentCityWeather
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: {value in
                    print(value as Any)
                    self.setDailyData(data: value)
                }
            )
            .store(in: &self.cancellableSet)

     }
    
    func setHourly(data: CityWeatherSevenDays){
        guard let hourly = data.hourly else {return}
        for i in 0..<hourly.count{
            if i > 23 {break}
            self.hours.hours[i].temp = Int(hourly[i].temp!)
            var date:  Date {
                let offset = TimeInterval(data.timezoneOffset!)
                let dt = TimeInterval(hourly[i].dt)
                return Date(timeIntervalSince1970: dt + offset)
//                return Date(timeIntervalSince1970: dt)
            }
            let h = Calendar.current.component(.hour, from: date)
            self.hours.hours[i].hour = h
            self.hours.hours[i].typeWeather = decodeWeatherType(icon: hourly[i].weather![0].icon)
        }
    }
    
    func setSevenDays(data: CityWeatherSevenDays){
        print(data as Any)
        guard let daily = data.daily else {return}
        for i in 0..<daily.count{
            self.days.days[i].tempDay = Int(daily[i].temp.max)
            self.days.days[i].tempNight = Int(daily[i].temp.min)
            var date:  Date {
                let offset = TimeInterval(data.timezoneOffset!)
                let dt = TimeInterval(daily[i].dt)
                return Date(timeIntervalSince1970: dt + offset)
            }
            let dow = Calendar.current.component(.weekday, from: date)
            print(dow)
            self.days.days[i].dayOfWeek = dow - 1
            self.days.days[i].typeWeather = decodeWeatherType(icon: daily[i].weather[0].icon)
        }
    }
    
    func setDailyData(data: CurrentWeather){
        let timezone = TimeInterval(data.timezone ?? 0)
        // get date form response
        var date: Date {
            let d = TimeInterval(data.dt ?? 0) + timezone
            let r = Date(timeIntervalSince1970: d)
            return r
        }
        
        let dow = Calendar.current.component(.weekday, from: date)
        let dayNuber = Calendar.current.component(.day, from: date)
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        df.locale = Locale.current
        let monthName = df.string(from: date)
        self.currentDay.dayOfWeek = dow - 1
        self.dayName = self.currentDay.DayName[dow - 1] + ", \(dayNuber) \(monthName)"
        
        self.region.center = self.coordinate
        let now = Date()
        let dayDiff = Calendar.current.dateComponents([.day], from: now, to: date)
        // if today
        if dayDiff.day == 0 {
            let w = data.weather!
            self.currentDay.tempDay = Int(data.main?.tempMax ?? 0)
            self.currentDay.tempNight = Int(data.main?.tempMin ?? 0)
            self.currentDay.windSpeed = Int(data.wind?.speed ?? 0)
            self.currentDay.humidity = Int(data.main?.humidity ?? 0)
            self.currentDay.windDirect = decodeWindDirect(windDeg: data.wind?.deg ?? 0)
            self.currentDay.typeWeather = decodeWeatherType(icon: w[0].icon)
        }
    }
    
    
    private var degToDirect: [Int: WindDirect] = [0:.windN, 1:.windNE, 2:.windE,
                                                  3: .windSE,  4: .windS, 5: .windWS, 6: .windW, 7: .windWN]
    func decodeWindDirect(windDeg: Int) -> WindDirect{
        var res: WindDirect {
            var wd: Int = Int(Double(Double(windDeg) / 45.0 + 0.5))
            if wd >= 8{
                wd = 0
            }
            if degToDirect.index(forKey: wd) != nil{
                return degToDirect[wd]!
            }else{
                return .windN
            }
//            switch wd {
//            case 1: return .windNE
//            case 2: return .windE
//            case 3: return .windSE
//            case 4: return .windS
//            case 5: return .windWS
//            case 6: return .windW
//            case 7: return .windWN
//            default : return .windN
//            }
        }
        return res
    }

    private var weatherToType:[Icon: TypeWeather] = [
        .the01D: .dayBright,
        .the01N: .nigthBright,
        .the02D: .dayCloudy,
        .the02N: .nigthCloudy,
        .the03D: .dayCloudy,
        .the03N: .nigthCloudy,
        .the04D: .dayCloudy,
        .the04N: .nigthCloudy,
        .the09D: .dayRain,
        .the09N: .nigthRain,
        .the10D: .dayRain,
        .the10N: .nigthRain,
        .the11D: .dayThunder,
        .the11N: .nigthThunder,
        .the13D: .dayRain, //snow
        .the13N: .nigthRain,
        .the50D: .dayRain, //mist
        .the50N: .nigthRain
    ]
    func decodeWeatherType(icon: Icon) -> TypeWeather{
        if weatherToType.index(forKey: icon) != nil{
            return weatherToType[icon]!
        }
        return .dayBright
    }
    
    func saveLocation(){
        let defaults = UserDefaults.standard
        defaults.setValue(self.region.center.latitude, forKey: "city_lat")
        defaults.setValue(self.region.center.longitude, forKey: "city_long")
    }
}

struct DataModel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
