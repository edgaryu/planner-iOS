//
//  RoutineDetailViewController.swift
//  Planner
//
//  Created by Edgar Yu on 2/2/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

//struct Constants {
//    static let iconSize = 50
//}

class RoutineDetailViewController: UIViewController, UITextFieldDelegate, RoutineActionDelegate, IconsContainerDelegate {

    
    var actionTVC: RoutineActionTableViewController?
    var iconsCVC: IconsCollectionViewController?
    
    // temp
    var tempRoutineArray = [UIColor]()
    
    var actions = [Action]()
    var routineTitle: String?
    var editMode = false
    
    // NEW THIS BRANCH
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var currentIcon: UIButton!
    @IBOutlet weak var iconsContainerView: UIView!
    @IBOutlet weak var iconsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconsContainerBottomConstraint: NSLayoutConstraint!
    
    // Icons container view
//    @IBOutlet weak var iconsContainerView: UICollectionView!
//    @IBOutlet weak var iconsContainerHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var iconsContainerBottomConstraint: NSLayoutConstraint!
    let iconsContainerViewHeightWhenVisible = CGFloat(50)
    let iconsContainerViemBottomWhenVisible = CGFloat(16)
    //    var isIconsContainerViewHidden = false
    
    @IBOutlet weak var actionsContainerView: UIView!
    @IBOutlet weak var deleteRoutineButton: UIButton!
    

    /// ---------------------
    // ICONS: Current icon + icons contanier view
    // ---------------------
    
    @IBAction func currentIconButtonTapped(_ sender: UIButton) {
        //        isIconsContainerViewHidden = !isIconsContainerViewHidden
        
        if iconsContainerHeightConstraint.constant != 0 {
            hideIconsContainerView()
        } else {
            unhideIconsContainerView()
        }
        UIView.animate(withDuration: 0.35, animations: {
            () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideIconsContainerView() {
        iconsContainerHeightConstraint.constant = 0
        iconsContainerBottomConstraint.constant = 0
    }
    
    func unhideIconsContainerView() {
        iconsContainerBottomConstraint.constant = iconsContainerViemBottomWhenVisible
        iconsContainerHeightConstraint.constant = iconsContainerViewHeightWhenVisible
    }
    
    
    
    // ---------------------
    // Delegate functions
    // ---------------------
    
    // Update this actions with newActions
    func updateActions(with newActions: [Action]) {
        actions = newActions
    }
    
    // Update this tempRoutineArray with newIcons
    func updateIcons(with newIcons: [UIColor]) {
        tempRoutineArray = newIcons
    }
    
    // ---------------------
    // Animations
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
    
    // ---------------------
    // Edit actions
    // ---------------------
    @IBOutlet weak var editActionsButton: UIButton!
    
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
    
    // ---------------------
    // viewDidLoad()
    // ---------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set VC title
        if (actions.count == 0 && routineTitle == nil) {
            self.title = "New Routine"
        } else {
            self.title = routineTitle
        }

        // set delegates
        actionTextField.delegate = self
        
        // ---------------------
        // Customization
        // ---------------------
        
        // actionsContainer
        actionsContainerView.layer.borderWidth = 1
        actionsContainerView.layer.borderColor = UIColor.black.cgColor
        deleteRoutineButton.layer.cornerRadius = 5
        
        // iconsContainer
        iconsContainerView.layer.borderWidth = 1
        iconsContainerView.layer.borderColor = UIColor.lightGray.cgColor
        iconsContainerView.layer.cornerRadius = 5
        
        // currentIcon
        currentIcon.maskAsCircle()
        hideIconsContainerView()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "RoutineActionListSegue" {
//            actionTVC = segue.destination as? RoutineActionTableViewController
//
//            actionTVC?.actions = actions
//        }
        if let routineActionTVCDest = segue.destination as? RoutineActionTableViewController {
            actionTVC = routineActionTVCDest
            actionTVC?.actions = actions
            actionTVC?.delegate = self
            actionTVC?.editMode = editMode
        }
        if let iconsCVCDest = segue.destination as? IconsCollectionViewController {
            iconsCVC = iconsCVCDest
            iconsCVC?.icons = tempRoutineArray
            iconsCVC?.delegate = self
            
        }
    }

}

extension UIButton {
    func maskAsCircle() {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}


