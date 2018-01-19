//
//  AddActionCell.swift
//  Planner
//
//  Created by Edgar Yu on 1/14/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

@objc protocol AddActionCellDelegate: class {
    func addActionButtonTapped(sender: AddActionCell, text: String)
}

class AddActionCell: UITableViewCell, UITextFieldDelegate {
    var delegate: AddActionCellDelegate?

    @IBOutlet weak var addActionTextField: UITextField!
    
    // press enter on text field -> add routine
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addActionTextField {
            handleAddRoutine()
            return false
        }
        return true
    }
    
    @IBAction func addActionButton(_ sender: UIButton) {
        handleAddRoutine()
    }
    
    // Prompts delegate (AddRoutineListViewController) to add action to routine
    func handleAddRoutine() {
        guard let text = addActionTextField.text, !text.isEmpty else {
            return
        }
        delegate?.addActionButtonTapped(sender: self, text: addActionTextField.text!)
        
        // reset text field
        addActionTextField.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addActionTextField.delegate = self;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
