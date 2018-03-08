//
//  EditRoutineTitleCell.swift
//  Planner
//
//  Created by Edgar Yu on 1/15/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

@objc protocol EditRoutineTitleCellDelegate: class {
    func routineTitleFieldEdited(text: String)
}

class EditRoutineTitleCell: UITableViewCell, UITextFieldDelegate {
    var delegate: EditRoutineTitleCellDelegate?
    var routineTitle: String?

    @IBOutlet weak var routineTitleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.routineTitleTextField.delegate = self
    }
    @IBAction func routineTitleTextFieldEditing(_ sender: UITextField) {
//        self.routineTitle = sender.text
        delegate?.routineTitleFieldEdited(text: sender.text!)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let text = routineTitle, !text.isEmpty else {
//            return
//        }
//        delegate?.routineTitleFieldEdited(text: text)
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
