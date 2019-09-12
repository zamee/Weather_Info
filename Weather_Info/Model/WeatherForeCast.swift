// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherforeCast = try? newJSONDecoder().decode(WeatherforeCast.self, from: jsonData)

import Foundation

// MARK: - WeatherforeCast
struct WeatherforeCast: Codable {
    let latitude, longitude: Double
    let timezone: String
    let currently: Currently
    let hourly: Hourly
    let daily: Daily
    let flags: Flags
    let offset: Int
}

// MARK: - Currently
struct Currently: Codable {
    let time: Int
    let summary: Summary
    let icon: String
    let nearestStormDistance: Int?
    let precipIntensity, precipProbability: Double
    let temperature, apparentTemperature, dewPoint, humidity: Double
    let pressure, windSpeed, windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
}

enum Summary: String, Codable {
    case humidAndOvercast = "Humid and Overcast"
    case lightRainAndHumid = "Light Rain and Humid"
    case possibleDrizzleAndHumid = "Possible Drizzle and Humid"
    case possibleLightRainAndHumid = "Possible Light Rain and Humid"
    case rainAndHumid = "Rain and Humid"
    case HumidAndFoggy = "Humid and Foggy"
}

// MARK: - Daily
struct Daily: Codable {
    let summary: String
    let icon: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime, sunsetTime: Int
    let moonPhase, precipIntensity, precipIntensityMax: Double
    let precipIntensityMaxTime: Int
    let precipProbability: Double
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint, humidity, pressure, windSpeed: Double
    let windGust: Double
    let windGustTime, windBearing: Int
    let cloudCover: Double
    let uvIndex, uvIndexTime: Int
    let visibility, ozone, temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}

// MARK: - Flags
struct Flags: Codable {
    let sources: [String]
    let nearestStation: Double
    let units: String
    
    enum CodingKeys: String, CodingKey {
        case sources
        case nearestStation = "nearest-station"
        case units
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let summary: String
    let icon: String
    let data: [Currently]
}
