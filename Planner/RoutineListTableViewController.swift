//
//  RoutineListTableViewController.swift
//  Planner
//
//  Created by Edgar Yu on 1/14/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class RoutineListTableViewController: UITableViewController {

    var routines = [Routine]()
    
    // add routine alert
    @IBAction func addRoutineButtonTapped(_ sender: UIBarButtonItem) {
        let addRoutineAlert = UIAlertController(title: "Add new routine", message: "", preferredStyle: UIAlertControllerStyle.alert)
        addRoutineAlert.addTextField { (textField) in
            textField.text = ""
        }
        addRoutineAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        // Successfully add new routine
        addRoutineAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { action in
            guard let newRoutineTitle =  addRoutineAlert.textFields?.first!.text else {
                print("Add new routine error")
                return
            }
            let newRoutine = Routine(routineTitle: newRoutineTitle, subroutines: [Subroutine]())
            self.routines.append(newRoutine)
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.routines.count-1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
            
            self.saveRoutinesToStorage()
            
        }))
        self.present(addRoutineAlert, animated: true, completion: nil)
    }
    
    // save routines to file
    func saveRoutinesToStorage() {
        Routine.saveToFile(routines: self.routines)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        routines = Routine.loadFromFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineListCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = routines[indexPath.row].routineTitle
        cell.detailTextLabel?.text = "\(routines[indexPath.row].subroutines.count) subroutines"
        return cell
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        if segue.identifier == "saveAddRoutine" {
            let routineDetailController = segue.source as! RoutineDetailViewController

            // add/editing routine
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // change title, actions
                var thisRoutine = routines[selectedIndexPath.row]
//                thisRoutine.routineTitle = routineTitle
                thisRoutine.subroutines = routineDetailController.subroutines
                routines[selectedIndexPath.row] = thisRoutine
                tableView.reloadRows(at: [selectedIndexPath], with: .none)

            }
                // add new routine
                // depr b/c add routine is only in listVC
//                else {
//                    let newIndexPath = IndexPath(row: routines.count, section: 0)
//                    let newRoutine = Routine(routineTitle: routineTitle, subroutines: routineDetailController.subroutines)
//                    routines.append(newRoutine)
//                    tableView.insertRows(at: [newIndexPath], with: .automatic)
//                }
            
            saveRoutinesToStorage()
            
        }
        else if segue.identifier == "deleteRoutine" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                routines.remove(at: selectedIndexPath.row)
                tableView.reloadData()
            }
            saveRoutinesToStorage()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRoutineSegue" {
            let routineDetailController = segue.destination
                as! RoutineDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedRoutine = routines[indexPath.row]
            routineDetailController.routineTitle = selectedRoutine.routineTitle
            routineDetailController.subroutines = selectedRoutine.subroutines
        }
    }

}
