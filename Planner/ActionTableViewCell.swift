//
//  ActionTableViewCell.swift
//  Planner
//
//  Created by Edgar Yu on 2/8/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

protocol ActionCellDelegate: class {
    func actionNameEdited(sender: ActionTableViewCell, newTitle: String)
}

class ActionTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: ActionCellDelegate?
    
    var editMode : Bool?
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionLabelTextField: UITextField!
    
    
    @IBAction func actionLabelTextFieldEditing(_ sender: UITextField) {
        delegate?.actionNameEdited(sender: self, newTitle: actionLabelTextField.text!)
    }
    
    // press enter on text field -> add action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == actionLabelTextField {
            actionLabelTextField.resignFirstResponder()
            return false
        }
        return true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actionLabelTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
