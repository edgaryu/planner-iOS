//
//  RoutineDetailViewController.swift
//  Planner
//
//  Created by Edgar Yu on 2/2/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit
import SnapKit

//struct Constants {
//    static let iconSize = 50
//}

class RoutineDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, RoutineActionDelegate, IconsContainerDelegate, addEditCompletedDelegate {
    
    var actionTVC: RoutineActionTableViewController?
    var iconsCVC: IconsCollectionViewController?
    
    // Data
    var routineTitle: String?
    var subroutines = [Subroutine]() {
    }
    var currentSubroutine = 0
    
    // ?
    var editMode = false
    
    // Icons container view // unneeded?
//    @IBOutlet weak var iconsContainerView: UICollectionView!
    
    // self.view child
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var userView: UIView!
    
    // upper userView child
    @IBOutlet weak var iconsContainerView: UIView!
    @IBOutlet weak var descTextLabel: UILabel!
    
    // lower userView child
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var addActionStackView: UIStackView!
    @IBOutlet weak var actionsContainerView: UIView!
    @IBOutlet weak var editActionsButton: UIButton!
    
    // ---------------------
    // Delegate functions (DATA)
    // ---------------------
    
    // Update this actions with newActions
    func updateActions(with newActions: [Action]) {
        //        actions = newActions
        subroutines[currentSubroutine].actions = newActions
    }
    
    // Called from iconsContainerView. call routineaddeditvc
    func addNewSubroutine() {
        performSegue(withIdentifier: "triggerAddSubroutine", sender: Any?.self)
        
    }
    
    func addNewSubroutine(iconURL: URL?, desc: String?) {
        print("add")
        
        var newIconURL : URL?
        if let iconURL = iconURL {
            newIconURL = iconURL
        } else {
            newIconURL = nil
        }
        
        var newDesc : String?
        if let desc = desc {
            newDesc = desc
        } else {
            newDesc = nil
        }
        
        let newSubroutine = Subroutine(newIconURL: newIconURL, newDesc: newDesc)
        subroutines.append(newSubroutine)
    }
    
    func deleteExistingSubroutine() {
        print("delete \(currentSubroutine)")
    }
    
    func editExistingSubroutine(iconURL: URL?, desc: String?) {
        print("edit")
    }
    
    // ---------------------
    // ICONS: Current icon + icons container view
    // ---------------------
    

    
    // ---------------------
    //  Description (textview)
    // ---------------------
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if descTextView.textColor == UIColor.lightGray {
//            descTextView.text = nil
//            descTextView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if descTextView.text.isEmpty {
//            descTextView.text = "Add a description..."
//            descTextView.textColor = UIColor.lightGray
//        }
//        descTextView.resignFirstResponder()
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        subroutines[currentSubroutine].desc = descTextView.text
//    }
    
    // ---------------------
    // Edit actions
    // ---------------------
    
    // ---------------------
    // Add new action (textfield) (DATA)
    // ---------------------
    
    @IBOutlet weak var actionTextField: UITextField!
    @IBAction func addActionButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        handleAddAction()
    }
    
    // press enter on text field -> add action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == actionTextField {
            handleAddAction()
            return false
        }
        return true
    }
    
    func handleAddAction() {
        guard let newAction = actionTextField.text, !newAction.isEmpty else {
            print("Action text field empty")
            return
        }
        
        subroutines[currentSubroutine].actions.append(Action(actionTitle: newAction))
        actionTVC?.actions = self.subroutines[currentSubroutine].actions
        actionTVC?.tableView.reloadData()
        actionTextField.resignFirstResponder()
        actionTextField.text = ""
    }
    
    // ---------------------
    // Bottom nav bar
    // ---------------------
    
    
//    @IBAction func deleteSubroutineButtonTapped(_ sender: UIButton) {
//        // confirmation msg
//        let deleteSubroutineAlert = UIAlertController(title: "Delete this subroutine?", message: "", preferredStyle: UIAlertControllerStyle.alert)
//        deleteSubroutineAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//        deleteSubroutineAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
//
//            DispatchQueue.main.async {
////                self.collectionView?.reloadData()
////                self.delegate?.updateIcons(with: self.icons)
//            }
//
//        }))
//        self.present(deleteSubroutineAlert, animated: true, completion: nil)
//
//        // if only 1 subroutine (auto init) -> not saved, so back
//        // if only 1 subroutine (saved) -> remove subroutine, unwind
//
//        // if 1+ subroutine, delete, switch to next in index.
//    }
    
    // ---------------------
    // viewDidLoad()
    // ---------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set VC title
//        if (subroutines.count == 0 && routineTitle == nil) {
//            self.title = "New Routine"
//        } else {
//            self.title = routineTitle
//        }
        self.title = routineTitle

        // set delegates
        actionTextField.delegate = self
//        descTextView.delegate = self
        
        // Initialize view with data
//        currentIcon.setImage(UIImage(named: subroutines[currentSubroutine].icon.rawValue), for: UIControlState.normal)
//        if let subroutineDesc = subroutines[currentSubroutine].desc {
//            descTextView.text = subroutineDesc
//        }
        
//        self.hideKeyboard()
        
        updateUI()
        
        print(subroutines)
    }

    // MARK: - Navigation
    
    @IBAction func unwindToRoutineDetailVC(segue: UIStoryboardSegue) {
//        if segue.identifier == "saveSubroutine" {
////            let addEdit
//
//        }
//        else if segue.identifier == "deleteSubroutine" {
//
//        }
    }
    
    // Called before viewDidLoad()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If empty routines == 0 subroutines, make new subroutine
        if (subroutines.count == 0) {
            subroutines.append(Subroutine(at: currentSubroutine))
        }
        
        // RoutineDetailVC in-house segues
        if let routineActionTVCDest = segue.destination as? RoutineActionTableViewController {
            actionTVC = routineActionTVCDest
            actionTVC?.actions = subroutines[currentSubroutine].actions
            actionTVC?.delegate = self
            actionTVC?.editMode = editMode
        }
        if let iconsCVCDest = segue.destination as? IconsCollectionViewController {
            iconsCVC = iconsCVCDest
//            iconsCVC?.icons = tempRoutineArray
            iconsCVC?.subroutines = self.subroutines
            iconsCVC?.delegate = self

        }
        if let addEditVC = segue.destination as? RoutineAddEditViewController {
            addEditVC.delegate = self
        }

        // External segues
        if segue.identifier == "triggerAddSubroutine" {
            if let routineAddEditVC = segue.destination as? RoutineAddEditViewController {
                routineAddEditVC.newSubroutineState = true
            }
        }
        
//        if segue.identifier == "AddSubroutine" {
        
//        }
//        else if segue.identifier == "EditSubroutine" {
    
//        }
        
    }

}

// ---------------------
// Customization
// ---------------------

// Button Animation for edit/add action
func animateButton(_ sender: UIButton) {
    sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    
    UIView.animate(withDuration: 2.0, delay: 0,
                   usingSpringWithDamping: CGFloat(0.20),
                   initialSpringVelocity: CGFloat(6.0),
                   options: UIViewAnimationOptions.allowUserInteraction,
                   animations: {
                    sender.transform = CGAffineTransform.identity
    },
                   completion: { Void in()  }
    )
}

extension UIButton {
    func maskAsCircle() {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}



