//
//  RoutineDetailViewController.swift
//  Planner
//
//  Created by Edgar Yu on 2/2/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class RoutineDetailViewController: UIViewController, UITextFieldDelegate, RoutineActionDelegate {
    
    var actionTVC: RoutineActionTableViewController?

    var actions = [Action]()
    var routineTitle: String?
    var editMode = false
    
    @IBOutlet weak var actionsContainerView: UIView!
    @IBOutlet weak var deleteRoutineButton: UIButton!
    
    // Delete routine
    @IBAction func deleteRoutineButtonTapped(_ sender: UIButton) {
        
        let deleteRoutineAlert = UIAlertController(title: "Delete this routine", message: "", preferredStyle: UIAlertControllerStyle.alert)
        deleteRoutineAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        deleteRoutineAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (_) in
            self.performSegue(withIdentifier: "deleteRoutine", sender: self)
        }))
        self.present(deleteRoutineAlert, animated: true, completion: nil)
    }
    
    
    
    // Delegate functions
    func updateActions(with newActions: [Action]) {
        actions = newActions
    }
    
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
    
    // ---------------------
    // Edit actions
    // ---------------------
    @IBOutlet weak var editActionsButton: UIButton!
    @IBAction func editActionButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        editMode = !editMode
        
        
        // Change edit mode
        if (editMode) {
            editActionsButton.setImage(UIImage(named: "icons8-compose-filled-40"), for: .normal)
            actionTVC?.tableView.isEditing = true
            
        } else {
            editActionsButton.setImage(UIImage(named: "icons8-compose-40"), for: .normal)
            actionTVC?.tableView.isEditing = false
        }
        actionTVC?.editMode? = editMode
        actionTVC?.tableView.reloadData()
    
    }
    
    // ---------------------
    // Add new action
    // ---------------------
    
    @IBOutlet weak var actionTextField: UITextField!
    @IBAction func addActionButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        handleAddRoutine()
    }
    
    // press enter on text field -> add action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == actionTextField {
            print("hi")
            handleAddRoutine()
            
            return false
        }
        return true
    }
    func handleAddRoutine() {
        guard let newAction = actionTextField.text, !newAction.isEmpty else {
            print("Action text field empty")
            return
        }
        
        actions.append(Action(actionTitle: newAction))
        actionTVC?.actions = self.actions
        actionTVC?.tableView.reloadData()
        actionTextField.resignFirstResponder()
        actionTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (actions.count == 0 && routineTitle == nil) {
            self.title = "New Routine"
        } else {
            self.title = routineTitle
        }

        // set delegate
        actionTextField.delegate = self
        
        // Customization
        actionsContainerView.layer.borderWidth = 1
        actionsContainerView.layer.borderColor = UIColor.black.cgColor
        deleteRoutineButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "RoutineActionListSegue" {
//            actionTVC = segue.destination as? RoutineActionTableViewController
//
//            actionTVC?.actions = actions
//        }
        if let vc = segue.destination as? RoutineActionTableViewController {
            actionTVC = vc
            actionTVC?.actions = actions
            actionTVC?.delegate = self
            actionTVC?.editMode = editMode
        }
    }

}
