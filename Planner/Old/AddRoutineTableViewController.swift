//
//  AddRoutineTableViewController.swift
//  Planner
//
//  Created by Edgar Yu on 1/14/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class AddRoutineTableViewController: UITableViewController, AddActionCellDelegate, EditActionCellDelegate, EditRoutineTitleCellDelegate {
    
    
    var actions = [Action]()
    var routineTitle : String?
    let actionsSection = 2
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    // Delegate methods
    func routineTitleFieldEdited(text: String) {
        routineTitle = text
        checkIfSaveEnabled()
    }
    
    func addActionButtonTapped(sender: AddActionCell, text: String) {
//        actions.append(Action(actionTitle: text, completed: false))
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: actions.count-1, section: actionsSection)], with: .automatic)
        tableView.endUpdates()
    }
    
    func toggleActionCompletion(sender: EditActionCell) {
//        if let indexPath = tableView.indexPath(for: sender) {
//            var action = actions[indexPath.row]
//            action.completed = !action.completed
//            actions[indexPath.row] = action
//            tableView.reloadRows(at8: [indexPath], with: .automatic)
//        }
    }
    
    func deleteAction(sender: EditActionCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            actions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func actionNameEdited(sender: EditActionCell, newActionName: String) {
        if let indexPath = tableView.indexPath(for: sender) {
            var action = actions[indexPath.row]
            action.actionTitle = newActionName
            actions[indexPath.row] = action
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // If new empty routine
        if (actions.count == 0 && routineTitle == nil) {
            self.title = "New Routine"
        } else {
            self.title = routineTitle
            
        }
        self.tableView.isEditing = true
        checkIfSaveEnabled()
    
    }
    
    // if routine title exists, enable save bar button, else disable
    func checkIfSaveEnabled() {
        if let routineTitle = routineTitle, !routineTitle.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true;
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != actionsSection {
            return 1
        } else {
            return actions.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // edit routine title cell
        if (indexPath.section == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditRoutineTitleCell") as? EditRoutineTitleCell else { fatalError("Could not dequeue a cell")
            }
            cell.delegate = self
            cell.routineTitleTextField.text = routineTitle
            return cell
        }
        // add action cell
        else if (indexPath.section == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddActionCell") as? AddActionCell else { fatalError("Could not dequeue a cell")
            }
            cell.delegate = self
            return cell
        }
        // edit action cell
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditActionCell") as? EditActionCell else { fatalError("Could not dequeue a cell")
            }
            cell.delegate = self
            
            let action = actions[indexPath.row]
//            cell.actionCompletedButton?.isSelected = action.completed
            cell.actionNameTextField?.text = action.actionTitle
            
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Routine Name"
        case 1:
            return "Add new action"
        case actionsSection:
            return "Action(s)"
        default:
            return "Default Section"
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // ?: does this change if delete button is shown on left?
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let action = actions[fromIndexPath.row]
        actions.remove(at: fromIndexPath.row)
        actions.insert(action, at: to.row)
    }
 
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if (indexPath.section == actionsSection) { return true }
        else { return false }
    }
    
    // Confine action reordering within the actions section
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (proposedDestinationIndexPath.section != actionsSection) {
            return IndexPath(row: 0, section: actionsSection)
        }
        else {
            return proposedDestinationIndexPath
            
        }
    }

    // Confine row height to 44 to force button sizes to stay constant
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
