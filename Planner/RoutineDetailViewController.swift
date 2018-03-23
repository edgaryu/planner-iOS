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

class RoutineDetailViewController: UIViewController, UITextFieldDelegate, RoutineActionDelegate, IconsContainerDelegate, addEditCompletedDelegate, UIPopoverPresentationControllerDelegate {
    
    var actionTVC: RoutineActionTableViewController?
    var iconsCVC: IconsCollectionViewController?
    
    // From List to DetailVC
    var subroutines = [Subroutine]()
    var routineTitle: String?
    
    // Self
    var currentSubroutine = 0
    var toEditSubroutineIndex : IndexPath?
    
    // Toggles
    var editActionsMode = false
    
    // Icons container view // unneeded?
//    @IBOutlet weak var iconsContainerView: UICollectionView!
    
    // parent containers
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var userView: UIView!
    
    // top half elements
    @IBOutlet weak var iconsContainerView: UIView!
    var addIconButton : UIButton!
    @IBOutlet weak var descTextLabel: UILabel!
    
    // bottom half elements
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var addActionStackView: UIStackView!
    @IBOutlet weak var actionsContainerView: UIView!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var editActionsButton: UIButton!
    
    // ---------------------
    // Delegate functions (DATA)
    // ---------------------
    
    // RoutineAction functions
    func updateActions(with newActions: [Action]) {
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
    func triggerDeleteSubroutine(at indexPath: IndexPath) {
        deleteSubroutine(at: indexPath)
    }
    func updateCurrentSubroutine(with newSubIndex: Int) {
        currentSubroutine = newSubIndex
    }
    
    func reloadRoutineDetailVC() {
        iconsCVC?.subroutines = self.subroutines
        iconsCVC?.collectionView?.reloadData()
        
        // if empty
        if (subroutines.count == 0) {
//            loadEmptyRoutineDetailVC()
            descTextLabel.text = ""
            actionTVC?.actions = [Action]()
            actionTVC?.tableView.reloadData()
            return
        }
        
        let newSubroutine = subroutines[currentSubroutine]
        descTextLabel.text = newSubroutine.desc ?? ""
        actionTVC?.actions = newSubroutine.actions
        actionTVC?.tableView.reloadData()
    }
    
    // addEditCompletedDelgate functions
    func addNewSubroutine(iconPath: String?, desc: String?) {
        
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
        reloadRoutineDetailVC()
    }
    func deleteSubroutine(at toEditSubroutineIndex: IndexPath) {
        subroutines.remove(at: toEditSubroutineIndex.row)
        
        // if currentIndex no longer in range
        if (currentSubroutine >= subroutines.count) {
            currentSubroutine = 0
        }
        reloadRoutineDetailVC()
    }
    func editExistingSubroutine(iconPath: String?, desc: String?, at subroutineIndex: IndexPath) {
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
        
        reloadRoutineDetailVC()
    }
    
    // ---------------------
    // Helper functions
    // ---------------------
    private func loadEmptyRoutineDetailVC() {
        
    }
    
//    func saveRoutinesToStorage() {
//        Routine.saveToFile(routines: self.subroutines)
//    }
    
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
    
    
    
    // Weather button
    @IBAction func weatherButtonTapped(_ sender: UIButton) {
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
    
    
    @IBAction func editActionsButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        editActionsMode = !editActionsMode
        
        if (editActionsMode) {
            editActionsButton.setImage(UIImage(named: "setting-on"), for: .normal)
            actionTVC?.tableView.isEditing = true
        } else {
            editActionsButton.setImage(UIImage(named: "setting-off"), for: .normal)
            actionTVC?.tableView.isEditing = false
        }
        actionTVC?.editMode? = editActionsMode
        actionTVC?.tableView.reloadData()

    }
    
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
        // Initialize view with data
        if (subroutines.count != 0) {
            descTextLabel.text = subroutines[currentSubroutine].desc ?? ""
        } else {
            descTextLabel.text = ""
        }
        
        
        // set delegates
        actionTextField.delegate = self
        
        // add icon button
        addIconButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
        addIconButton.addTarget(self, action: #selector(triggerNewSubroutine), for: UIControlEvents.touchUpInside)
        

        //
        // need different update UI for if 1+ subroutine, no subroutine
        //
        
        // Layout the view with SnapKit
        updateUI()
        if (subroutines.count == 0) {
            return
        }

//        self.hideKeyboard()

        print("\(subroutines.count) subroutines")
//        for subroutine in subroutines {
//            print("\(subroutine.desc ?? "") ")
//            print("\(subroutine.actions.count) ")
//        }
    }

    // MARK: - Navigation
    
    @IBAction func unwindToRoutineDetailVC(segue: UIStoryboardSegue) {
    }
    
    // Called before viewDidLoad()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // RoutineDetailVC in-house segues
        if let routineActionTVCDest = segue.destination as? RoutineActionTableViewController {
            actionTVC = routineActionTVCDest
            if (subroutines.count != 0) {
                actionTVC?.actions = self.subroutines[currentSubroutine].actions
            }
            actionTVC?.delegate = self
            actionTVC?.editMode = self.editActionsMode
        }
        if let iconsCVCDest = segue.destination as? IconsCollectionViewController {
            iconsCVC = iconsCVCDest
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



