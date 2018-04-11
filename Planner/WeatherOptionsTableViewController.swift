//
//  WeatherOptionsTableViewController.swift
//  Planner
//
//  Created by Edgar Yu on 3/30/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit
import GooglePlaces

protocol WeatherOptionsDelegate : class {
    func weatherOptionsUpdated(with newOptions: WeatherOptions)
}

class WeatherOptionsTableViewController: UITableViewController, LocationSearchDelegate {
    
//    @IBOutlet weak var searchBarView: UIView!
//
//    var resultsViewController: GMSAutocompleteResultsViewController?
//    var searchController: UISearchController?
//    var resultView: UITextView?
    
    var delegate: WeatherOptionsDelegate?
    var weatherOptions = WeatherOptions()
    var currentRoutine = 0
    
    @IBOutlet weak var locationLabel: UILabel!
    
    //routine options
    @IBOutlet weak var waitBetweenSwitch: UISwitch!
    @IBOutlet weak var waitBetweenTextField: UITextField!
    
    @IBOutlet weak var minDaysSwitch: UISwitch!
    @IBOutlet weak var minDaysTextField: UITextField!
    
    @IBOutlet weak var avoidRainSwitch: UISwitch!
    
    @IBOutlet weak var tempRangeSwitch: UISwitch!
    @IBOutlet weak var minTempTextField: UITextField!
    @IBOutlet weak var maxTempTextField: UITextField!
    
    // delegate methods
    func locationFound(location: String, coordinates: CLLocationCoordinate2D) {
//        locationLabel.text = location
//        weatherOptions.locationName = location
        weatherOptions.latitude = coordinates.latitude
        weatherOptions.longitude = coordinates.longitude
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if let locationName = placeMark.locality  {
                self.weatherOptions.locationName = "\(locationName)"
                self.locationLabel.text = locationName
            } else{
                self.weatherOptions.locationName = nil
            }
            
            // save
            self.saveWeatherOptionsToStorage()
        })
        
        
    }
    
    // private methods
    private func saveWeatherOptionsToStorage() {
        delegate?.weatherOptionsUpdated(with: self.weatherOptions)
        
        var routines = Routine.loadFromFile()
        routines[currentRoutine].weatherOptions = self.weatherOptions
        Routine.saveToFile(routines: routines)
        
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        switch(sender) {
        case waitBetweenSwitch:
            weatherOptions.daysBetweenBool = waitBetweenSwitch.isOn
        case minDaysSwitch:
            weatherOptions.minDaysPerWeekBool = minDaysSwitch.isOn
        case avoidRainSwitch:
            weatherOptions.noRaining = avoidRainSwitch.isOn
        case tempRangeSwitch:
            weatherOptions.tempRangeBool = tempRangeSwitch.isOn
        default:
            break
        }

        // update data
        saveWeatherOptionsToStorage()
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        switch(sender) {
        case waitBetweenTextField:
            if let txt = waitBetweenTextField.text {
                weatherOptions.daysBetween = Int(txt)
            }
        case minDaysTextField:
            if let txt = minDaysTextField.text {
                weatherOptions.minDaysPerWeek = Int(txt)
            }
        case minTempTextField:
            if let txt = minTempTextField.text {
                weatherOptions.minTemp = Int(txt)
            }
        case maxTempTextField:
            if let txt = maxTempTextField.text {
                weatherOptions.maxTemp = Int(txt)
            }
        default:
            break
        }
        
        //save
        saveWeatherOptionsToStorage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // take data and input data accordingly
        var routines = Routine.loadFromFile()
        
        let existingWeatherOptions = routines[currentRoutine].weatherOptions
        
        self.weatherOptions = existingWeatherOptions
        locationLabel.text = weatherOptions.locationName ?? "Select a location"
        
        waitBetweenSwitch.isOn = weatherOptions.daysBetweenBool
        minDaysSwitch.isOn = weatherOptions.minDaysPerWeekBool
        avoidRainSwitch.isOn = weatherOptions.noRaining
        tempRangeSwitch.isOn = weatherOptions.tempRangeBool
        
        if let daysBetween = weatherOptions.daysBetween {
            waitBetweenTextField.text = String(daysBetween)
        }
        if let minDaysPerWeek = weatherOptions.minDaysPerWeek {
            minDaysTextField.text = String(minDaysPerWeek)
        }
        if let minTemp = weatherOptions.minTemp {
            minTempTextField.text = String(minTemp)
        }
        if let maxTemp = weatherOptions.maxTemp {
            maxTempTextField.text = String(maxTemp)
        }


    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0) {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section, indexPath.row) {
        case (1,0):
            if (waitBetweenSwitch.isOn) {
                return CGFloat(84)
            } else {
                return CGFloat(44)
            }
        case (1,1):
            if (minDaysSwitch.isOn) {
                return CGFloat(84)
            } else {
                return CGFloat(44)
            }
        case (2, 1):
            if (tempRangeSwitch.isOn) {
                return CGFloat(84)
            } else {
                return CGFloat(44)
            }
        default:
            return CGFloat(44)
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row == 0 && indexPath.section == 0) {
//            performSegue(withIdentifier: "locationSegue", sender: Any?.self)
//        }
//    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationVC = segue.destination as? LocationSearchViewController {
            locationVC.delegate = self
        }
    }
 

}


