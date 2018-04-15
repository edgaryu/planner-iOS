//
//  ActionTableViewCell.swift
//  Planner
//
//  Created by Edgar Yu on 2/8/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

protocol ActionCellDelegate: class {
    func actionNameEdited(sender: ActionCollectionViewCell, newTitle: String)
    func deleteAction(sender: ActionCollectionViewCell)
}

class ActionCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    var delegate: ActionCellDelegate?
    
    var editMode : Bool?
    
    @IBOutlet weak var actionCellView: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionLabelTextField: UITextField!
    
    @IBOutlet weak var deleteActionButton: UIButton!
    @IBOutlet weak var editingStackView: UIStackView!
    
    @IBAction func deleteActionButtonTapped(_ sender: UIButton) {
        delegate?.deleteAction(sender: self)
    }
    
    @IBAction func actionLabelTextFieldEditing(_ sender: UITextField) {
        actionLabel.text = sender.text
        delegate?.actionNameEdited(sender: self, newTitle: actionLabelTextField.text!)
    }
    
    // press enter on text field -> add action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == actionLabelTextField {
            actionLabelTextField.resignFirstResponder()
        }
        return true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actionLabelTextField.delegate = self
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
