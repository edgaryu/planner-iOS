//
//  RoutineWeatherViewController.swift
//  Planner
//
//  Created by Edgar Yu on 3/27/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class RoutineWeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, WeatherOptionsDelegate {

    var currentRoutine = 0
    var optionUpdatePending = false
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var updateWeatherButton: UIButton!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    var weatherResponse : WeatherResponse?
    var weatherOptions = WeatherOptions()
    
    private func updateWeatherButtonState() {
        
        // toggle weather button
        if weatherOptions.longitude != nil && weatherOptions.latitude != nil {
            updateWeatherButton.isEnabled = true
            
            if (optionUpdatePending) {
                updateWeatherButton.setImage(UIImage(named: "update-pending"), for: .normal)
            } else {
                updateWeatherButton.setImage(UIImage(named: "update-non"), for: .normal)
            }
        } else {
            updateWeatherButton.isEnabled = false
            
            updateWeatherButton.setImage(UIImage(named: "update-non"), for: .normal)
        }
    }
    
    private func checkWeatherCollectionViewVisibile() {
        // existing weather data
        if weatherResponse != nil {
            weatherCollectionView.isHidden = false
        } else {
            // no weather data present
            weatherCollectionView.isHidden = true
        }
    }
    
    
    // delegate functions
    func weatherOptionsUpdated(with newOptions: WeatherOptions) {
        weatherOptions = newOptions

        optionUpdatePending = true
        updateWeatherButtonState()
        
    }
    
    // Button actions
    @IBAction func exitRoutineWeatherButtonTapped(_ sender: UIButton) {
        // reload routineVC with new data
    }
    
    
    func fetchWeatherData(using weatherRequest: [String: String], completion: @escaping (WeatherResponse?) -> Void) {
        // do network request
        let baseURL = URL(string: "https://fathomless-plateau-86787.herokuapp.com/weathersuggest/")!
    
        let url = baseURL.withQueries(weatherRequest)!
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let weatherData = try? jsonDecoder.decode(WeatherResponse.self, from: data) {
                completion(weatherData)
            } else {
                print("Either no data was returned, or data was not properly decoded.")
                completion(nil)
            }
        }
        task.resume()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        self.updateWeatherButton.isEnabled = false
        
        // Get weather options
        var weatherRequest = [String: String]()
//        let routines = Routine.loadFromFile()
//        let existingWeatherOptions = routines[currentRoutine].weatherOptions
        
        if weatherOptions.longitude != nil && weatherOptions.latitude != nil {
            
            weatherRequest["latitude"] = "\(weatherOptions.latitude!)"
            weatherRequest["longitude"] = "\(weatherOptions.longitude!)"
            
            if (weatherOptions.noRaining) {
                weatherRequest["noRaining"] = weatherOptions.noRaining ? "true" : "false"
            }
            if (weatherOptions.daysBetweenBool) {
                if let daysBetween = weatherOptions.daysBetween {
                    weatherRequest["daysBetween"] = String(daysBetween)
                }
            }
            if (weatherOptions.minDaysPerWeekBool) {
                if let minDaysPerWeek = weatherOptions.minDaysPerWeek {
                    weatherRequest["minDaysPerWeek"] = String(minDaysPerWeek)
                }
            }
            if (weatherOptions.tempRangeBool) {
                if let minTemp = weatherOptions.minTemp, let maxTemp = weatherOptions.maxTemp {
                    weatherRequest["minTemp"] = String(minTemp)
                    weatherRequest["maxTemp"] = String(maxTemp)
                }
            }
        } else {
            return
        }

        
        fetchWeatherData(using: weatherRequest) { (weatherResponse) in
            guard let weatherResponse = weatherResponse else {
                DispatchQueue.main.async {
                    // set error label msg
                }
                
                return
            }
            
            self.weatherResponse = weatherResponse
            
            // save to file
            var routines = Routine.loadFromFile()
            routines[self.currentRoutine].recentWeatherResponse = self.weatherResponse
            Routine.saveToFile(routines: routines)
            
            DispatchQueue.main.async {
                self.weatherCollectionView.isHidden = false
                self.updateWeatherButton.isEnabled = true
                self.weatherCollectionView.reloadData()
                if let locationName = self.weatherOptions.locationName {
                    self.locationNameLabel.text = locationName
                    self.locationNameLabel.font = self.locationNameLabel.font.withSize(24)
                    self.locationNameLabel.textColor = UIColor.black
                }
                self.checkWeatherCollectionViewVisibile()
                self.optionUpdatePending = false
                self.updateWeatherButtonState()
                print("Done")
            }
        }
        
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
    }
    
    // ----------------
    // View did load
    // ----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let routines = Routine.loadFromFile()
        weatherOptions = routines[currentRoutine].weatherOptions
        weatherResponse = routines[currentRoutine].recentWeatherResponse
        
        
        // set locationNameLabel
        if weatherResponse != nil, let locationName = weatherOptions.locationName {
            locationNameLabel.text = locationName
            locationNameLabel.font = locationNameLabel.font.withSize(24)
            locationNameLabel.textColor = UIColor.black
        } else {
            locationNameLabel.text = "Set your location in settings"
            locationNameLabel.font = locationNameLabel.font.withSize(16)
            locationNameLabel.textColor = UIColor.darkGray
        }
        
        updateWeatherButtonState()

        checkWeatherCollectionViewVisibile()
    }
    
    // Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let weatherResponse = weatherResponse {
            return weatherResponse.weatherData.count
        } else {
            return 0
        }
    }
    
    // ----------------
    // Configure Weather Cell
    // ----------------
    
    private func monthIntToString(_ monthInt: Int) -> String {
        switch(monthInt) {
        case 1: return "Jan"
        case 2: return "Feb"
        case 3: return "Mar"
        case 4: return "Apr"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "Aug"
        case 9: return "Sep"
        case 10: return "Oct"
        case 11: return "Nov"
        case 12: return "Dec"
        default: return "Month"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        
        
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
        
        guard let weatherResponse = weatherResponse else {
            return cell
        }
        
        let thisDateInfo = weatherResponse.weatherData[indexPath.row]
        let dayName = thisDateInfo.dayName
        guard let month = thisDateInfo.date["month"], let date = thisDateInfo.date["day"], let high = thisDateInfo.high["fahrenheit"], let low = thisDateInfo.low["fahrenheit"] else {
                print("Error with parsing weatherData values")
                return cell
        }
        
        // reset data
        cell.dayLabel.textColor = UIColor.black
        cell.dayLabel.text = ""
        cell.tempHighLabel.text = ""
        cell.tempLowLabel.text = ""
        cell.dateLabel.text = ""
        cell.weatherIcon.image = nil
        for v in cell.statusView.subviews{
            v.removeFromSuperview()
        }

        // data
        cell.dayLabel.text = "\(dayName)"
        if (dayName == "Sat" || dayName == "Sun") {
            cell.dayLabel.textColor = UIColor.red
        }
        cell.dateLabel.text = "\(monthIntToString(month)) \(date)"
        cell.tempHighLabel.text = "\(high) °F"
        cell.tempLowLabel.text = "\(low) °F"
        
        
//        drizzle, rain, thunderstorm, clear, cloud
        // set image
        let condition = thisDateInfo.conditions.lowercased()
        if (condition.containsIgnoringCase(find: "thunderstorm")) {
            cell.weatherIcon.image = UIImage(named: "weather-storm")
        } else if (condition.containsIgnoringCase(find: "snow")) {
            cell.weatherIcon.image = UIImage(named: "weather-snow")
        } else if (condition.containsIgnoringCase(find: "rain")) {
            cell.weatherIcon.image = UIImage(named: "weather-rain")
        } else if (condition.containsIgnoringCase(find: "drizzle")) {
            cell.weatherIcon.image = UIImage(named: "weather-rain")
        } else if (condition.containsIgnoringCase(find: "cloud")) {
            cell.weatherIcon.image = UIImage(named: "weather-cloudy")
        } else if (condition.containsIgnoringCase(find: "clear")) {
            cell.weatherIcon.image = UIImage(named: "weather-sun")
        } else {
            cell.weatherIcon.image = nil
        }

        // set statusView
        // if no suggestions, empty statusView
        if (weatherResponse.suggestions == nil) {
            cell.statusView.isHidden = true
        } else {

            let numOfSuggestions = weatherResponse.suggestions!.count
            let suggestionMargin = 5
            let suggestionWidth = Int(cell.statusView.frame.width / 3) - suggestionMargin
            let suggestionHeight = cell.statusView.frame.height
            
            for i in (0 ..< numOfSuggestions) {
                var thisColor : UIColor
                let thisX = i * suggestionWidth + i * suggestionMargin
                
                // set color of status bars
                // FF6699, 00CCCC, 99FF00 best
                switch(i) {
                    // best to worst
                    
                    case 0: thisColor = UIColor(red:0.60, green:1.00, blue:0.00, alpha:1.0)
                    case 1: thisColor = UIColor(red:0.00, green:0.80, blue:0.80, alpha:1.0)
                    case 2: thisColor = UIColor(red:1.00, green:0.40, blue:0.60, alpha:1.0)
                    
                    default: thisColor = UIColor.black
                }
                let thisSuggestion = weatherResponse.suggestions![i]
                var indices : [Int] = []
                if let firstInd = thisSuggestion.first {
                    indices.append(firstInd)
                }
                if let secondInd = thisSuggestion.second {
                    indices.append(secondInd)
                }
                if let thirdInd = thisSuggestion.third {
                    indices.append(thirdInd)
                }
                
                
                for ind in indices {
                    if ind == indexPath.row {
                        let statusBar = UIView(frame: CGRect(x: thisX, y: 0, width: suggestionWidth, height: Int(suggestionHeight)))
                        statusBar.backgroundColor = thisColor
                        cell.statusView.addSubview(statusBar)
                    }
                }
            }
            
            cell.statusView.isHidden = false
        }

        
        return cell
    }
    
    @IBAction func unwindToWeatherVC(segue: UIStoryboardSegue) {
        updateWeatherButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        
        if let weatherOptionsTVC = navVC?.viewControllers.first as? WeatherOptionsTableViewController {
            weatherOptionsTVC.currentRoutine = self.currentRoutine
            weatherOptionsTVC.delegate = self
        }
    }
        
    
    
    
}

//extension URL {
//    func withQueries(_ queries: [String: String]) -> URL? {
//        var components = URLComponents(url: self,
//                                       resolvingAgainstBaseURL: true)
//        components?.queryItems = queries.flatMap
//            { URLQueryItem(name: $0.0, value: $0.1) }
//        return components?.url
//    }
//}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }

        return components?.url
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
