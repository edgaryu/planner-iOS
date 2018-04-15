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

class RoutineActionCollectionViewController: UICollectionViewController, ActionCellDelegate {
    var delegate: RoutineActionDelegate?

    var actions = [Action]()
    var editMode : Bool = false
    
    var longPressGesture: UILongPressGestureRecognizer!
    
    
    
    // Delegate function
    func actionNameEdited(sender: ActionCollectionViewCell, newTitle: String) {
        if let indexPath = collectionView?.indexPath(for: sender) {
            var action = actions[indexPath.row]
            action.actionTitle = newTitle
            actions[indexPath.row] = action

            syncWithRoutineDetailVC()
        }
    }
    
    func deleteAction(sender: ActionCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: sender) {
            actions.remove(at: indexPath.row)
            syncWithRoutineDetailVC()
//            tableView.deleteRows(at: [indexPath], with: .fade)
            collectionView?.deleteItems(at: [indexPath])
        }
        
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView?.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }
    
    func syncWithRoutineDetailVC() {
        delegate?.updateActions(with: actions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView?.addGestureRecognizer(longPressGesture)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // Collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionCell", for: indexPath) as! ActionCollectionViewCell
        
        cell.delegate = self
        cell.actionLabel?.text = actions[indexPath.row].actionTitle
        cell.actionLabelTextField?.text = actions[indexPath.row].actionTitle
        
        // layout
        cell.addSubview(cell.actionCellView)
//        cell.actionCellView.layer.borderWidth = 1
//        cell.actionCellView.layer.borderColor = UIColor.lightGray.cgColor
        cell.actionCellView.snp.makeConstraints{ (make) in
            make.top.left.right.bottom.equalTo(cell.actionCellView.superview!)
        }
        
        cell.actionCellView.addSubview(cell.actionLabel)
//        cell.actionLabel.backgroundColor = UIColor.blue
        cell.actionLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(cell.actionLabel.superview!).offset(20)
            make.right.equalTo(cell.actionLabel.superview!).offset(-20)
            make.centerY.equalTo(cell.actionLabel.superview!.center)
        }
        
        cell.actionCellView.addSubview(cell.editingStackView)
        cell.editingStackView.spacing = 10
        cell.editingStackView.snp.makeConstraints{ (make) in
            make.left.equalTo(cell.actionLabel.superview!).offset(20)
            make.right.equalTo(cell.actionLabel.superview!).offset(-20)
            make.centerY.equalTo(cell.actionLabel.superview!.center)
        }
        
        cell.editingStackView.addSubview(cell.deleteActionButton)
        cell.deleteActionButton.snp.makeConstraints{ (make) in
            make.height.equalTo(10)
            make.width.equalTo(10)
        }
        
        cell.editingStackView.addSubview(cell.actionLabelTextField)
        cell.actionLabelTextField.snp.makeConstraints{ (make) in
//            make.top.bottom.right.equalTo(cell.actionLabelTextField.superview!)
//            make.left.equalTo(cell.deleteActionButton.snp.right).offset(10)
        }
        
        
//        cell.actionCellView.addSubview(cell.actionLabelTextField)
//        cell.actionLabelTextField.snp.makeConstraints{ (make) in
//            make.left.equalTo(cell.actionLabel.superview!).offset(20)
//            make.right.equalTo(cell.actionLabel.superview!).offset(-20)
//            make.centerY.equalTo(cell.actionLabel.superview!.center)
//        }

        
        // Use either label or text field depending on editmode
        if (editMode) {
            cell.actionLabel?.isHidden = true
            cell.editingStackView?.isHidden = false
//            cell.actionLabelTextField?.isHidden = false
        } else {
            cell.actionLabel?.isHidden = false
//            cell.actionLabelTextField?.isHidden = true
            cell.editingStackView?.isHidden = true
        }
        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let action = actions[sourceIndexPath.row]
        actions.remove(at: sourceIndexPath.row)
        actions.insert(action, at: destinationIndexPath.row)
        syncWithRoutineDetailVC()
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            actions.remove(at: indexPath.row)
//            syncWithRoutineDetailVC()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//
//        }
//    }
//
//
//
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let action = actions[fromIndexPath.row]
//        actions.remove(at: fromIndexPath.row)
//        actions.insert(action, at: to.row)
//        syncWithRoutineDetailVC()
//    }
//
//
//
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//
//    // Confine row height to 44 to force button sizes to stay constant
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(40)
//    }
 
    

}
