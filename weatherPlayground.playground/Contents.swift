//: Playground - noun: a place where people can play

import UIKit


var apiResponse = ["weatherData":[["date":["month":4,"day":9,"year":2018],"high":["fahrenheit":95,"celsius":35],"low":["fahrenheit":61,"celsius":16],"conditions":"Clear","pop":0,"score":0.90234375],["date":["month":4,"day":10,"year":2018],"high":["fahrenheit":85,"celsius":29],"low":["fahrenheit":59,"celsius":15],"conditions":"Clear","pop":0,"score":0.92578125],["date":["month":4,"day":11,"year":2018],"high":["fahrenheit":75,"celsius":24],"low":["fahrenheit":54,"celsius":12],"conditions":"Clear","pop":10,"score":0.9625],["date":["month":4,"day":12,"year":2018],"high":["fahrenheit":69,"celsius":21],"low":["fahrenheit":53,"celsius":12],"conditions":"Clear","pop":0,"score":1],["date":["month":4,"day":13,"year":2018],"high":["fahrenheit":76,"celsius":24],"low":["fahrenheit":55,"celsius":13],"conditions":"Clear","pop":0,"score":1],["date":["month":4,"day":14,"year":2018],"high":["fahrenheit":82,"celsius":28],"low":["fahrenheit":57,"celsius":14],"conditions":"Clear","pop":0,"score":0.9328125],["date":["month":4,"day":15,"year":2018],"high":["fahrenheit":79,"celsius":26],"low":["fahrenheit":55,"celsius":13],"conditions":"Partly Cloudy","pop":0,"score":1]] ]
    
//    ,"suggestions":[["first":1,"second":3,"third":6,"sum":2.92578125],["first":1,"second":4,"third":6,"sum":2.92578125],["first":2,"second":4,"third":6,"sum":2.9625]]]

let jsonData = try JSONSerialization.data(withJSONObject: apiResponse)


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
    var high: [String: Int]
    var low: [String: Int]
    var conditions: String
    var pop: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case high
        case low
        case conditions
        case pop
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try valueContainer.decode([String: Int].self, forKey: CodingKeys.date)
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

let jsonDecoder = JSONDecoder()
let weatherRes = try? jsonDecoder.decode(WeatherResponse.self, from: jsonData)
print(weatherRes!)
