//
//  RoutineActionTableViewController.swift
//  Planner
//
//  Created by Edgar Yu on 2/2/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

protocol RoutineActionDelegate: class {
    func updateActions(with: [Action])
}

class RoutineActionTableViewController: UITableViewController, ActionCellDelegate {
    var delegate: RoutineActionDelegate?

    var actions = [Action]()
    var editMode : Bool?
    
    func syncWithRoutineDetailVC() {
        delegate?.updateActions(with: actions)
    }
    
    // Delegate functions
    func actionNameEdited(sender: ActionTableViewCell, newTitle: String) {
        if let indexPath = tableView.indexPath(for: sender) {
            var action = actions[indexPath.row]
            action.actionTitle = newTitle
            actions[indexPath.row] = action

            syncWithRoutineDetailVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as? ActionTableViewCell else { fatalError("Could not dequeue a cell") }

        // Configure the cell...

        cell.delegate = self
        cell.actionLabel?.text = actions[indexPath.row].actionTitle
        cell.actionLabelTextField?.text = actions[indexPath.row].actionTitle
        
        // Use either label or text field depending on editmode
        if let editMode = editMode {
            if (editMode) {
                cell.actionLabel?.isHidden = true
                cell.actionLabelTextField?.isHidden = false
            } else {
                cell.actionLabel?.isHidden = false
                cell.actionLabelTextField?.isHidden = true
            }
        }
        

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            actions.remove(at: indexPath.row)
            syncWithRoutineDetailVC()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let action = actions[fromIndexPath.row]
        actions.remove(at: fromIndexPath.row)
        actions.insert(action, at: to.row)
        syncWithRoutineDetailVC()
    }
 

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // Confine row height to 44 to force button sizes to stay constant
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
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
