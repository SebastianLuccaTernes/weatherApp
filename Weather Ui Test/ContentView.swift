//
//  ContentView.swift
//  Weather Ui Test
//
//  Created by Sebastian Ternes on 09.02.24.
//

import Foundation
import SwiftUI


struct ContentView: View {
    
    @State private var isNight = false
    @State private var weather : weatherAPI?
    @State private var addNumber = 0
    
    
    var body: some View {
        ZStack{
            backgroundLinear(isNight: $isNight)
            VStack{
                
                cityTextView(cityName: "Berlin")
                
                mainWheaterStatusView(mainImage: rightIcon(weather?.daily.weatherCode[0] ?? 0),
                                      mainTemperatur: Int(weather?.current.temperature2M ?? 0),
                                      minTemperatur: Int(weather?.daily.temperature2MMin [0] ?? 0),
                                      maxTemperatur: Int(weather?.daily.temperature2MMax [0] ?? 0))
                
                HStack (spacing: 20){
                    WheatherDayView(dayOfWeek: dayCalculator(1),
                                    imageName: rightIcon(weather?.daily.weatherCode[1] ?? 0),
                                    temperatur: Int(weather?.daily.temperature2MMax [1] ?? 0))
                    
                    WheatherDayView(dayOfWeek: dayCalculator(2),
                                    imageName: rightIcon(weather?.daily.weatherCode[2] ?? 0),
                                    temperatur: Int(weather?.daily.temperature2MMax [2] ?? 0))
                    
                    WheatherDayView(dayOfWeek: dayCalculator(3),
                                    imageName: rightIcon(weather?.daily.weatherCode[3] ?? 0),
                                    temperatur: Int(weather?.daily.temperature2MMax [3] ?? 0))
                    
                    WheatherDayView(dayOfWeek: dayCalculator(4),
                                    imageName: rightIcon(weather?.daily.weatherCode[4] ?? 0),
                                    temperatur: Int(weather?.daily.temperature2MMax [4] ?? 0))
                    
                    WheatherDayView(dayOfWeek: dayCalculator(5),
                                    imageName: rightIcon(weather?.daily.weatherCode[5] ?? 0),
                                    temperatur: Int(weather?.daily.temperature2MMax [5] ?? 0))
                    
                }
                Spacer()
                
                
                Button{
                    print("tapped")
                    isNight.toggle()
                } label: {
                    weatherButton(text: "Change Day Time",
                                  textColor: .blue,
                                  backroundColor: .white)
                }
                
                Spacer()
            }
            
        }
        
        .task {
            do{
                weather = try await getWeather()
            
                
            }catch weatherError.invalidURL{
                print("Invalid URL")
                
            }catch weatherError.invalidData{
                print("Invalid Data")
                
            }catch weatherError.invalidResponse{
                print("Invalid Response")
                
            }catch{
                print("unexpeted Error")
                
            }
            
        }
    
        
    }
    
    func getWeather() async throws -> weatherAPI{
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=52.5244&longitude=13.4105&current=temperature_2m,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin"
        
        guard let url = URL(string: endpoint) else {
            throw weatherError.invalidURL}

        
        let (data,response) = try await URLSession.shared.data(from: url)
        
       
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw weatherError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(weatherAPI.self, from: data)
            
            
        } catch{
            throw weatherError.invalidData
        }
        
    }
    
    func rightIcon (_ weatherCode : Int) -> String{
        
    var weatherIconCurrent = ""
        
        if weather?.current.isDay == 1 {
            
            switch weatherCode {
            case 0:
                weatherIconCurrent = "sun.max.fill"
            case 1...3:
                weatherIconCurrent = "cloud.sun.fill"
            case 45, 48:
                weatherIconCurrent = "cloud.fog.fill"
            case 51, 53, 55:
                weatherIconCurrent = "cloud.drizzle.fill"
            case 56, 57:
                weatherIconCurrent = "cloud.sleet.fill"
            case 61, 63, 65:
                weatherIconCurrent = "cloud.rain.fill"
            case 66, 67:
                weatherIconCurrent = "cloud.sleet.fill"
            case 71, 73, 75:
                weatherIconCurrent = "cloud.snow.fill"
            case 77:
                weatherIconCurrent = "cloud.snow.fill"
            case 80...82:
                weatherIconCurrent = "cloud.heavyrain.fill"
            case 85, 86:
                weatherIconCurrent = "cloud.hail.fill"
            case 95:
                weatherIconCurrent = "cloud.bolt.rain.fill"
            case 96, 99:
                weatherIconCurrent = "cloud.hail.fill"
            default:
                weatherIconCurrent = "questionmark.circle"
                
            }
        }else {
            switch weatherCode {
            case 0:
                weatherIconCurrent = "moon.fill"
            case 1...3:
                weatherIconCurrent = "cloud.moon.fill"
            case 45, 48:
                weatherIconCurrent = "cloud.fog.fill"
            case 51, 53, 55:
                weatherIconCurrent = "cloud.drizzle.fill"
            case 56, 57:
                weatherIconCurrent = "cloud.sleet.fill"
            case 61, 63, 65:
                weatherIconCurrent = "cloud.rain.fill"
            case 66, 67:
                weatherIconCurrent = "cloud.sleet.fill"
            case 71, 73, 75:
                weatherIconCurrent = "cloud.snow.fill"
            case 77:
                weatherIconCurrent = "cloud.snow.fill"
            case 80...82:
                weatherIconCurrent = "cloud.heavyrain.fill"
            case 85, 86:
                weatherIconCurrent = "cloud.hail.fill"
            case 95:
                weatherIconCurrent = "cloud.bolt.rain.fill"
            case 96, 99:
                weatherIconCurrent = "cloud.hail.fill"
            default:
                weatherIconCurrent = "questionmark.circle"
            }
        }
        
       return weatherIconCurrent
    }

    func dayCalculator(_ addNumber: Int) -> String {
        let calender = Calendar.current
        let rightNow : Date = .now
        let weekday = calender.component(.weekday, from: rightNow)
        var day = ""
        
        switch weekday + addNumber{
        case 1, 9:
            day = "SUN"
        case 2, 10:
            day = "MON"
        case 3, 11:
            day = "TUE"
        case 4, 12:
            day = "WED"
        case 5, 13:
            day = "THU"
        case 6, 14:
            day = "FRI"
        case 7, 15:
            day = "SAT"
        case 0, 8:
            day = "SUN"
        default:
            day = "Noday"
        }
        
        return day
        
    }
    
}


#Preview {
    ContentView()
}







struct WheatherDayView: View {
    
    var dayOfWeek : String
    var imageName : String
    var temperatur : Int
    
    var body: some View {
        VStack{
            Text (dayOfWeek)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.original)
                .frame(width: 40, height: 40)
            Text ("\(temperatur)°")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct backgroundLinear: View {
    
    @Binding var isNight : Bool
    
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? Color("darkgray") : Color("darkblue"), isNight ? Color("lightgray") : Color("lightblue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct cityTextView: View {
    var cityName : String
    
    var body: some View{
        Text (cityName)
        .font(.system(size: 32, weight: .medium, design: .default))
        .foregroundColor(.white)
        .padding()
    }
}

struct mainWheaterStatusView: View {
    var mainImage : String
    var mainTemperatur : Int
    var minTemperatur : Int
    var maxTemperatur : Int
    
    var body: some View {
        VStack (spacing: 10){
            Image(systemName: mainImage)
                .resizable()
                .renderingMode(.original)
                .frame(width: 180, height: 140)
            
            Text ("\(mainTemperatur)°")
                .font(.system(size: 70, weight: .bold, design: .default))
                .foregroundColor(.white)
            HStack{
    
                Text ("Min: \(minTemperatur)°")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text ("Max: \(maxTemperatur)°")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(.white)
            }
            
            
        }.padding(.bottom, 50)
    }
}





enum weatherError : Error {
    case invalidURL
    case invalidResponse
    case invalidData
}



// MARK: - weatherAPI
struct weatherAPI: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let currentUnits: CurrentUnits
    let current: Current
    let dailyUnits: DailyUnits
    let daily: Daily

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case dailyUnits = "daily_units"
        case daily
    }
}

// MARK: - Current
struct Current: Codable {
    let time: String
    let interval: Int
    let temperature2M: Double
    let isDay: Int

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case isDay = "is_day"
    }
}

// MARK: - CurrentUnits
struct CurrentUnits: Codable {
    let time, interval, temperature2M, isDay: String

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case isDay = "is_day"
    }
}

// MARK: - Daily
struct Daily: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2MMax, temperature2MMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}

// MARK: - DailyUnits
struct DailyUnits: Codable {
    let time, weatherCode, temperature2MMax, temperature2MMin: String

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}
