//
//  addIconCollectionViewCell.swift
//  Planner
//
//  Created by Edgar Yu on 2/13/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

protocol AddRoutineIconDelegate: class {
    func addNewRoutineIcon()
}

class addIconCollectionViewCell: UICollectionViewCell {
    var delegate: AddRoutineIconDelegate?
    
    
    @IBAction func addIconButtonTapped(_ sender: UIButton) {
        delegate?.addNewRoutineIcon()
    }
    
}
