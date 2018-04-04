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

protocol SyncDetailWithListDelegate: class {
    func syncWithList(with routines: [Routine])
    func deleteRoutine(at index: Int)
}

class RoutineDetailViewController: UIViewController, UITextFieldDelegate, RoutineActionDelegate, IconsContainerDelegate, addEditCompletedDelegate, UIPopoverPresentationControllerDelegate, RoutineEditPopoverDelegate {
    
    var actionTVC: RoutineActionTableViewController?
    var iconsCVC: IconsCollectionViewController?
    
    // From List to DetailVC
//    var routines = [Routine]()
    var subroutines = [Subroutine]()
    var routineTitle: String?
    var currentRoutine = 0 // used only when saving to storage
    var delegate: SyncDetailWithListDelegate?
    
    // Self
    var currentSubroutine = 0
    var toEditSubroutineIndex : Int?
    
    // Toggles
    var editActionsMode = false
    
    // Icons container view // unneeded?
//    @IBOutlet weak var iconsContainerView: UICollectionView!
    
    // parent containers
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var userView: UIView!
    
    // top half elements
    
    @IBOutlet weak var subroutineHeaderView: UIView!
//    var addIconButton : UIButton!
    @IBOutlet weak var editSubroutineButton: UIButton!
    @IBOutlet weak var addSubroutineButton: UIButton!
    @IBOutlet weak var subroutineHeaderLabel: UILabel!
    @IBOutlet weak var iconsContainerView: UIView!
    
    @IBOutlet weak var descTextLabelView: UIView!
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
        saveRoutinesToStorage()
    }
    
    // RoutineEditPopover
    func editRoutineTitle(with newTitle: String) {
        routineTitle = newTitle
        self.title = routineTitle
        
        saveRoutinesToStorage()
    }
    func deleteRoutine() {
        // pop, then save in RoutineList.
        delegate?.deleteRoutine(at: currentRoutine)
        popToRoutineListTVC()
    }
    private func popToRoutineListTVC() {
        if let routineListTVC = navigationController?.viewControllers[0] as? RoutineListTableViewController {
            navigationController?.popToViewController(routineListTVC, animated: true)
        }
    }
    
    
    // IconsContainerDelegate functions
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
        saveRoutinesToStorage()
        
        currentSubroutine = subroutines.count-1
        iconsCVC?.selectedIndex = currentSubroutine
        
        reloadRoutineDetailVC()
    }
    func deleteSubroutine(at toEditSubroutineIndex: Int) {
        subroutines.remove(at: toEditSubroutineIndex)
        saveRoutinesToStorage()
        
        // if currentIndex no longer in range
        if (currentSubroutine >= subroutines.count || currentSubroutine == toEditSubroutineIndex) {
            currentSubroutine = 0
        }
        
        iconsCVC?.selectedIndex = currentSubroutine
        reloadRoutineDetailVC()
    }
    func editExistingSubroutine(iconPath: String?, desc: String?, at subroutineIndex: Int) {
        if iconPath == iconPath {
            subroutines[subroutineIndex].iconPath = iconPath
        } else {
            subroutines[subroutineIndex].iconPath = nil
        }
        
        if desc == desc {
            subroutines[subroutineIndex].desc = desc
        } else {
            subroutines[subroutineIndex].desc = nil
        }
        
        saveRoutinesToStorage()
        reloadRoutineDetailVC()
    }
    
    // ---------------------
    // Helper functions
    // ---------------------
    private func loadEmptyRoutineDetailVC() {
        
    }
    
    // save routines to file
    private func saveRoutinesToStorage() {
        var routines = Routine.loadFromFile()
        routines[currentRoutine].subroutines = self.subroutines
        routines[currentRoutine].routineTitle = self.routineTitle ?? ""
        Routine.saveToFile(routines: routines)
        delegate?.syncWithList(with: routines)
    }
    

    // ------------------------------------------
    // UI Functions
    // ------------------------------------------
    
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
    // Edit routine popover
    // ---------------------
    
    @objc func routineEditBarButtonTapped(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "routineEditVC")
            as! RoutineEditPopoverViewController
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.routineTitle = routineTitle
        
        
        vc.preferredContentSize = CGSize(width: self.view.frame.width, height: 150)
        
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .any
        ppc?.delegate = self
        ppc?.barButtonItem = navigationItem.rightBarButtonItem

        present(vc, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // ---------------------
    // Subroutine header view
    // ---------------------
    func triggerNewSubroutine() {
        performSegue(withIdentifier: "triggerAddSubroutine", sender: Any?.self)
    }

    func triggerEditSubroutine(at indexPath: Int) {
        toEditSubroutineIndex = indexPath
        performSegue(withIdentifier: "triggerEditSubroutine", sender: Any?.self)
        toEditSubroutineIndex = nil
    }
    
    @IBAction func editSubroutineButtonTapped(_ sender: UIButton) {
        triggerEditSubroutine(at: currentSubroutine)
    }
    
    @IBAction func addSubroutineButtonTapped(_ sender: UIButton) {
        triggerNewSubroutine()
    }
    
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
        actionTextField.resignFirstResponder()
        
        guard let newAction = actionTextField.text, !newAction.isEmpty else {
            print("Action text field empty")
            return
        }
        
        subroutines[currentSubroutine].actions.append(Action(actionTitle: newAction))
        saveRoutinesToStorage()
        
        actionTVC?.actions = self.subroutines[currentSubroutine].actions
        actionTVC?.tableView.reloadData()
        
        actionTextField.text = ""
    }
    
    // ---------------------
    // Bottom nav bar
    // ---------------------

    // Weather button
//    @IBAction func weatherButtonTapped(_ sender: UIButton) {
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let popoverController = storyboard.instantiateViewController(withIdentifier: "iconPopover")
//        popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
//
//
//        if let popover: UIPopoverPresentationController =
//            popoverController.popoverPresentationController {
//            let sourceView = sender as UIView
//            popover.delegate = self
//            popoverController.preferredContentSize = CGSize(width: 100, height: 30)
////            popover.backgroundColor = popoverController.view.backgroundColor
//            popover.sourceView = sourceView
//            popover.sourceRect = sourceView.bounds
//        }
//
//        present(popoverController, animated: true, completion: nil)
//
//    }
    
    
    @IBAction func editActionsButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        editActionsMode = !editActionsMode
        
        if (editActionsMode) {
            editActionsButton.setImage(UIImage(named: "edit-action-done"), for: .normal)
            actionTVC?.tableView.isEditing = true
        } else {
            editActionsButton.setImage(UIImage(named: "edit-action"), for: .normal)
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
//        addIconButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
//        addIconButton.addTarget(self, action: #selector(triggerNewSubroutine), for: UIControlEvents.touchUpInside)
        
        // calls routineEdit
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(routineEditBarButtonTapped(_:)))
        

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
//            print("\(subroutine.iconPath ?? "")")
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
        if let addEditVC = segue.destination as? RoutineAddEditTableViewController {
            addEditVC.delegate = self
        }

        // External segues
        if segue.identifier == "triggerAddSubroutine" {
            if let routineAddEditVC = segue.destination as? RoutineAddEditTableViewController {
                routineAddEditVC.newSubroutineState = true
            }
        }
        
        if segue.identifier == "triggerEditSubroutine" {
            if let routineAddEditVC = segue.destination as? RoutineAddEditTableViewController {
                routineAddEditVC.newSubroutineState = false
                
                if let toEditSubroutineIndex = toEditSubroutineIndex {
                    let subroutine = subroutines[toEditSubroutineIndex]
                    routineAddEditVC.desc = subroutine.desc
                    routineAddEditVC.toEditIconPath = subroutine.iconPath
                    routineAddEditVC.toEditSubroutineIndex = toEditSubroutineIndex
                }
            }
        }
        
        if segue.identifier == "routineWeather" {
            if let routineWeatherVC = segue.destination as? RoutineWeatherViewController {
                routineWeatherVC.currentRoutine = currentRoutine
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



