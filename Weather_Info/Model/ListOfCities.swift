// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let listOfCities = try? newJSONDecoder().decode(ListOfCities.self, from: jsonData)

import Foundation

// MARK: - ListOfCity
struct ListOfCity: Codable {
    let id: Int
    let name: String
    let lat, lon: Double
    let url: String
}

typealias ListOfCities = [ListOfCity]
