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

class RoutineDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, RoutineActionDelegate, IconsContainerDelegate, addEditCompletedDelegate, UIPopoverPresentationControllerDelegate {
    
    
    
    
    var actionTVC: RoutineActionTableViewController?
    var iconsCVC: IconsCollectionViewController?
    
    // Data
    var routineTitle: String?
    var subroutines = [Subroutine]()
    var currentSubroutine = 0
    var toEditSubroutineIndex : IndexPath?
    
    // ?
    var editMode = false
    
    // Icons container view // unneeded?
//    @IBOutlet weak var iconsContainerView: UICollectionView!
    
    // self.view child
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var userView: UIView!
    
    // upper userView child
    @IBOutlet weak var iconsContainerView: UIView!
    var addIconButton : UIButton!
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
    
    // IconsContainerDelegate functions
    @objc func triggerNewSubroutine() {
        performSegue(withIdentifier: "triggerAddSubroutine", sender: Any?.self)
    }
    func triggerEditSubroutine(at indexPath: IndexPath) {
        toEditSubroutineIndex = indexPath
        performSegue(withIdentifier: "triggerEditSubroutine", sender: Any?.self)
        toEditSubroutineIndex = nil
    }
    func updateCurrentSubroutine(with newSubIndex: Int) {
        currentSubroutine = newSubIndex
    }
    
    func reloadRoutineDetailVC() {
//        currentSubroutine = newSubIndex
        
        let newSubroutine = subroutines[currentSubroutine]
        iconsCVC?.collectionView?.reloadData()
        descTextLabel.text = newSubroutine.desc ?? ""
        actionTVC?.actions = newSubroutine.actions
        actionTVC?.tableView.reloadData()
    }
    
    
    // addEditCompletedDelgate functions
    func addNewSubroutine(iconPath: String?, desc: String?) {
        print("add")
        
        var newIconPath : String?
        if let iconURL = iconPath {
            newIconPath = iconURL
        } else {
            newIconPath = nil
        }
        
        var newDesc : String?
        if let desc = desc {
            newDesc = desc
        } else {
            newDesc = nil
        }
        
        let newSubroutine = Subroutine(newIconPath: newIconPath, newDesc: newDesc)
        subroutines.append(newSubroutine)
        
        iconsCVC?.subroutines = self.subroutines
//        iconsCVC?.collectionView?.reloadData()
        reloadRoutineDetailVC()
        
    }
    func deleteExistingSubroutine() {
        print("delete \(currentSubroutine)")
    }
    func editExistingSubroutine(iconPath: String?, desc: String?, subroutineIndex: IndexPath) {
        if iconPath == iconPath {
            subroutines[subroutineIndex.row].iconPath = iconPath
        } else {
            subroutines[subroutineIndex.row].iconPath = nil
        }
        
        if desc == desc {
            subroutines[subroutineIndex.row].desc = desc
        } else {
            subroutines[subroutineIndex.row].desc = nil
        }
        
        iconsCVC?.subroutines = self.subroutines
//        iconsCVC?.collectionView?.reloadData()
        reloadRoutineDetailVC()
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
    
    
    
    @IBOutlet weak var button2: UIButton!
    @IBAction func button2Tapped(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverController = storyboard.instantiateViewController(withIdentifier: "iconPopover")
        popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        
        if let popover: UIPopoverPresentationController =
            popoverController.popoverPresentationController {
            let sourceView = sender as UIView
            popover.delegate = self
            popoverController.preferredContentSize = CGSize(width: 100, height: 30)
//            popover.backgroundColor = popoverController.view.backgroundColor
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
        }
        
        present(popoverController, animated: true, completion: nil)

    }
    // UIPopoverPresentationControllerDelegate method
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
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
        
        // add icon button
        addIconButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
        addIconButton.addTarget(self, action: #selector(triggerNewSubroutine), for: UIControlEvents.touchUpInside)

        // set delegates
        actionTextField.delegate = self
//        descTextView.delegate = self
        
        // Initialize view with data
        descTextLabel.text = subroutines[currentSubroutine].desc ?? ""
        
//        self.hideKeyboard()
        
        // Layout the view with SnapKit
        updateUI()
        
        print("\(subroutines.count) subroutines")
//        for subroutine in subroutines {
//            print("\(subroutine.desc ?? "") ")
//            print("\(subroutine.actions.count) ")
//        }
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
        
        if segue.identifier == "triggerEditSubroutine" {
            if let routineAddEditVC = segue.destination as? RoutineAddEditViewController {
                routineAddEditVC.newSubroutineState = false
                if let toEditSubroutineIndex = toEditSubroutineIndex {
                    let subroutine = subroutines[toEditSubroutineIndex.row]
                    routineAddEditVC.desc = subroutine.desc
                    routineAddEditVC.toEditIconPath = subroutine.iconPath
                    routineAddEditVC.toEditSubroutineIndex = toEditSubroutineIndex
                }
            }
        }
        
//        if segue.identifier == "popoverSegue" {
//
//            let popoverViewController = segue.destination
//            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
//            popoverViewController.popoverPresentationController!.delegate = self
//
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

extension UIImageView {
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



