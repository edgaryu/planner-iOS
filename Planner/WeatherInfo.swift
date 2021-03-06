//
//  WeatherInfo.swift
//  Planner
//
//  Created by Edgar Yu on 3/30/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import Foundation
import UIKit

// unneeded
struct WeatherRequest {
    var latitude: Double
    var longitude: Double
    var daysBetween: Int?
    var minDaysPerWeek: Int?
    var noRaining: String?
    var minTemp: Int?
    var maxTemp: Int?
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct WeatherResponse: Codable {
    var weatherData: [WeatherData]
    var suggestions: [WeatherSuggestion]?
    
    enum CodingKeys: String, CodingKey {
        case weatherData
        case suggestions
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.weatherData = try valueContainer.decode([WeatherData].self, forKey: CodingKeys.weatherData)
        self.suggestions = try? valueContainer.decode([WeatherSuggestion].self, forKey: CodingKeys.suggestions)
    }
    
}



struct WeatherData : Codable {
    var date: [String: Int]
    var dayName: String
    var high: [String: Int]
    var low: [String: Int]
    var conditions: String
    var pop: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case dayName
        case high
        case low
        case conditions
        case pop
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try valueContainer.decode([String: Int].self, forKey: CodingKeys.date)
        self.dayName = try valueContainer.decode(String.self, forKey: CodingKeys.dayName)
        self.high = try valueContainer.decode([String: Int].self, forKey: CodingKeys.high)
        self.low = try valueContainer.decode([String: Int].self, forKey: CodingKeys.low)
        self.conditions = try valueContainer.decode(String.self, forKey: CodingKeys.conditions)
        self.pop = try valueContainer.decode(Int.self, forKey: CodingKeys.pop)
    }
}

struct WeatherSuggestion : Codable {
    var first: Int?
    var second: Int?
    var third: Int?
    var sum: Double?
    
    enum CodingKeys: String, CodingKey {
        case first
        case second
        case third
        case sum
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.first = try? valueContainer.decode(Int.self, forKey: CodingKeys.first)
        self.second = try? valueContainer.decode(Int.self, forKey: CodingKeys.second)
        self.third = try? valueContainer.decode(Int.self, forKey: CodingKeys.third)
        self.sum = try? valueContainer.decode(Double.self, forKey: CodingKeys.sum)
        
    }
}

struct WeatherOptions: Codable {
    var locationName: String?
    var latitude: Double?
    var longitude: Double?
    
    var daysBetween: Int?
    var daysBetweenBool: Bool
    var minDaysPerWeek: Int?
    var minDaysPerWeekBool: Bool
    var noRaining: Bool
    var tempRangeBool: Bool
    var minTemp: Int?
    var maxTemp: Int?
    
    init() {
        self.daysBetweenBool = false
        self.minDaysPerWeekBool = false
        self.noRaining = false
        self.tempRangeBool = false
    }
}
