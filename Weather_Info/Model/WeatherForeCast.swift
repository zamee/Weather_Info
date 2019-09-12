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
    let daily: Daily
    let offset: Int
}

// MARK: - Currently
struct Currently: Codable {
    let time: Int
    let summary: String
    let icon: String
    let temperature, apparentTemperature, dewPoint, humidity: Double
    let pressure, windSpeed, windGust: Double
}

enum Summary: String, Codable {
    case humidAndOvercast = "Humid and Overcast"
    case lightRainAndHumid = "Light Rain and Humid"
    case possibleDrizzleAndHumid = "Possible Drizzle and Humid"
    case possibleLightRainAndHumid = "Possible Light Rain and Humid"
    case rainAndHumid = "Rain and Humid"
    case HumidAndFoggy = "Humid and Foggy"
    case PartlyCloudy = "Partly Cloudy"
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
    let temperatureHigh: Double
    let temperatureHighTime: Double
    let temperatureLow: Double
    let temperatureLowTime: Double
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Double
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Double
    let dewPoint, humidity, pressure, windSpeed: Double
    let temperatureMinTime: Double
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}
