//
//  RoutineListTableViewController.swift
//  Planner
//
//  Created by Edgar Yu on 1/14/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit



class RoutineListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SyncDetailWithListDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var newRoutineTextField: UITextField!
    @IBOutlet weak var routinesCollectionView: UICollectionView!
    
    var routines = [Routine]()
    
    
    
    // delegate functions
    func syncWithList(with routines: [Routine]) {
        self.routines = routines
        self.routinesCollectionView.reloadData()
    }
    func deleteRoutine(at index: Int) {
        routines.remove(at: index)
        saveRoutinesToStorage()
        self.routinesCollectionView.reloadData()
    }
    
    // Add new routine
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newRoutineTextField {
            newRoutineTextField.resignFirstResponder()
            
            guard let newRoutineTitle = newRoutineTextField.text, !newRoutineTitle.isEmpty else {
                return true
            }
            
            let newRoutine = Routine(named: newRoutineTitle)
            self.routines.append(newRoutine)
            self.saveRoutinesToStorage()
            
            routinesCollectionView.reloadData()
            newRoutineTextField.text = ""
            
        }
        return true
    }
    
    // save routines to file
    func saveRoutinesToStorage() {
        Routine.saveToFile(routines: self.routines)
    }
    
//    @objc private func toggleEditing() {
//        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
//        navigationItem.leftBarButtonItem?.title = self.tableView.isEditing ? "Done" : "Edit"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        routines = Routine.loadFromFile()
        
        newRoutineTextField.delegate = self
        
//        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing)) // create a bat button
//        navigationItem.leftBarButtonItem = editButton // assign button
    }

    // MARK: - Table view data source

    // Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routines.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineListCell", for: indexPath) as! RoutineListCollectionViewCell

        // Configure the cell...
        cell.routineTitleLabel.text = routines[indexPath.row].routineTitle
        cell.subroutinesLabel.text = "\(routines[indexPath.row].subroutines.count) subroutines"
        return cell
    }
 
    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
//
//            let alertController = UIAlertController(title: "Edit routine title", message: "", preferredStyle: .alert)
//            alertController.addTextField(configurationHandler: { (textField) in
//                textField.placeholder = ""
//            })
//            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
//            alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler:  { alert in
//                let textField = alertController.textFields![0] as UITextField
//
//
//                if let newRoutineTitle = textField.text {
//                    self.routines[indexPath.row].routineTitle = newRoutineTitle
//                    self.saveRoutinesToStorage()
//
//                    DispatchQueue.main.async {
//                        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
//                    }
//                }
//            }))
//
//
//            self.present(alertController, animated: true, completion: nil)
//        }
////        edit.backgroundColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1)
//
//        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
//            self.routines.remove(at: indexPath.row)
//            self.saveRoutinesToStorage()
//            DispatchQueue.main.async {
//                self.tableView?.reloadData()
//            }
//
//        }
//        delete.backgroundColor = .red
//
//        return [delete, edit]
//    }
 

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            routines.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//
//        self.saveRoutinesToStorage()
//    }
 

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }


    // MARK: - Navigation

    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
//        if segue.identifier == "saveAddRoutine" {
//            let routineDetailVC = segue.source as! RoutineDetailViewController
//
//            // add/editing routine
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                // change title, actions
//                var thisRoutine = routines[selectedIndexPath.row]
////                thisRoutine.routineTitle = routineTitle
//                thisRoutine.subroutines = routineDetailVC.subroutines
//                routines[selectedIndexPath.row] = thisRoutine
//                tableView.reloadRows(at: [selectedIndexPath], with: .none)
//
//            }
//            saveRoutinesToStorage()
//
//        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Goes to RoutineDetail
        if segue.identifier == "listToDetailSegue" {
            
            
            let routineDetailController = segue.destination
                as! RoutineDetailViewController
            let cell = sender as! RoutineListCollectionViewCell
            let index = routinesCollectionView.indexPath(for: cell)!.row
            
            let selectedRoutine = routines[index]
            routineDetailController.routineTitle = selectedRoutine.routineTitle
            routineDetailController.subroutines = selectedRoutine.subroutines
            routineDetailController.currentRoutine = index
            routineDetailController.delegate = self
        }

    }

}
