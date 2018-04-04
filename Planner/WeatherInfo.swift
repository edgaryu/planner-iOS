//
//  WeatherInfo.swift
//  Planner
//
//  Created by Edgar Yu on 3/30/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import Foundation
import UIKit

struct WeatherData : Codable {
    var date: [String: Int]
    var high: [String: Int]
    var low: [String: Int]
    var conditions: String
    var pop: Int
}

struct WeatherOptions: Codable {
    var locationName: String?
    var latitude: Double?
    var longitude: Double?
    
    var daysBetween: Int?
    var daysBetweenBool: Bool?
    var minDaysPerWeek: Int?
    var minDaysPerWeekBool: Bool?
    var noRaining: Bool?
    var tempRangeBool: Bool?
    var minTemp: Int?
    var maxTemp: Int?
}
