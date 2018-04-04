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
    @IBOutlet weak var weatherErrorLabel: UILabel!
    
    var weatherData = [WeatherData]()
    
    private func updateWeatherButtonState() {
        if (optionUpdatePending) {
            updateWeatherButton.setImage(UIImage(named: "update-pending"), for: .normal)
        } else {
            updateWeatherButton.setImage(UIImage(named: "update-non"), for: .normal)
        }
    }
    
    // delegate functions
    func weatherOptionsUpdated() {
        optionUpdatePending = true
        updateWeatherButtonState()
    }
    
    // Button actions
    @IBAction func exitRoutineWeatherButtonTapped(_ sender: UIButton) {
        // reload routineVC with new data
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        // do network request
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "DEMO_KEY",
            "date": "2011-07-13"
        ]
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data,
            response, error) in
            if let data = data,
                let photoDictionary = try? jsonDecoder.decode([String:
                    String].self, from: data) {
                print(photoDictionary)
            }
        }
    
        
        
        // only update this after network request is done, else, don't update.
//        optionUpdatePending = false
//        updateWeatherButtonState()
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
    }
    
    private func checkIfLocationAvailable() {
        let routines = Routine.loadFromFile()
        let existingWeatherOptions = routines[currentRoutine].weatherOptions
        
        if existingWeatherOptions.longitude != nil && existingWeatherOptions.latitude != nil {
            updateWeatherButton.isEnabled = true
            weatherCollectionView.isHidden = false
            weatherErrorLabel.isHidden = true
        }
        // no location info available, disable update button
        else {
            updateWeatherButton.isEnabled = false
            weatherCollectionView.isHidden = true
            weatherErrorLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherErrorLabel.isHidden = true

        checkIfLocationAvailable()
        
        
    }
    
    // Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1

        
        return cell
    }
    
    @IBAction func unwindToWeatherVC(segue: UIStoryboardSegue) {
        checkIfLocationAvailable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        
        if let weatherOptionsTVC = navVC?.viewControllers.first as? WeatherOptionsTableViewController {
            weatherOptionsTVC.currentRoutine = self.currentRoutine
            weatherOptionsTVC.delegate = self
        }
    }
        
    
    
    
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

