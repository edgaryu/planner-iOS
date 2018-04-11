//
//  WeatherCollectionViewCell.swift
//  Planner
//
//  Created by Edgar Yu on 3/28/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempHighLabel: UILabel!
    @IBOutlet weak var tempLowLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var cellForegroundView: UIView!
    @IBOutlet weak var cellBackgroundView: UIView!
}
