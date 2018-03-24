//
//  IconPopoverViewController.swift
//  Planner
//
//  Created by Edgar Yu on 3/13/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

protocol RoutineEditPopoverDelegate : class {
    func editRoutineTitle(with newTitle: String)
    func deleteRoutine()
}

class RoutineEditPopoverViewController: UIViewController {
    
    var delegate: RoutineEditPopoverDelegate?
    
    @IBOutlet weak var saveRoutineButton: UIButton!
    @IBOutlet weak var routineTitleTextField: UITextField!
    var routineTitle : String?
    
   
    
    // Top header buttons
    @IBAction func cancelRoutineEdit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRoutineEdit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        if let routineTitle = routineTitle {
            delegate?.editRoutineTitle(with: routineTitle)
        } else {
            return
        }
        
    }
    
    // Routine title edit
    @IBAction func routineTitleEditing(_ sender: UITextField) {
        routineTitle = sender.text
        
        // toggle save button
        if routineTitle == nil || routineTitle == "" {
            self.saveRoutineButton.isEnabled = false
        } else {
            self.saveRoutineButton.isEnabled = true
        }
    }
    
    // Delete button
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        
//            delegate?.deleteSubroutine(at: cellIndexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let routineTitle = routineTitle {
            routineTitleTextField.text = routineTitle
            self.saveRoutineButton.isEnabled = true
        } else {
            self.saveRoutineButton.isEnabled = false
        }
        
        
        
    }
    
}
