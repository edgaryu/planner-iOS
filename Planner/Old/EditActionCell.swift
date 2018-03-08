//
//  EditActionCell.swift
//  Planner
//
//  Created by Edgar Yu on 1/14/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

@objc protocol EditActionCellDelegate: class {
    func toggleActionCompletion(sender: EditActionCell)
    func deleteAction(sender: EditActionCell)
    func actionNameEdited(sender: EditActionCell, newActionName: String)
}

class EditActionCell: UITableViewCell, UITextFieldDelegate {
    var delegate: EditActionCellDelegate?

    @IBOutlet weak var actionCompletedButton: UIButton!
    @IBOutlet weak var actionNameTextField: UITextField!
    @IBOutlet weak var deleteActionButton: UIButton!
    
    // Prompt delegate to delete action
    @IBAction func deleteActionButtonTapped(_ sender: UIButton) {
        delegate?.deleteAction(sender: self)
    }
    
    // Prompt delegate to toggle completed property of an action
    @IBAction func completedButtonTapped(_ sender: UIButton) {
        delegate?.toggleActionCompletion(sender: self)
    }
    
    // Prompt delegate to edit action name
    @IBAction func actionNameTextFieldEditing(_ sender: UITextField) {
        delegate?.actionNameEdited(sender: self, newActionName: sender.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.actionNameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
