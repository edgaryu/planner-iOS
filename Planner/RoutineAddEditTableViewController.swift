//
//  RoutineAddEditViewController.swift
//  Planner
//
//  Created by Edgar Yu on 3/6/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

protocol addEditCompletedDelegate : class {
    func addNewSubroutine(iconPath: String?, desc: String?)
    func deleteSubroutine(at toEditSubroutineIndex: IndexPath)
    func editExistingSubroutine(iconPath: String?, desc: String?, at subroutineIndex: IndexPath)
}

class RoutineAddEditTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var availableIconsCollectionView: UICollectionView!
    
    var delegate : addEditCompletedDelegate?
    var newSubroutineState : Bool? = true
    
    // only if in editing subroutine state
    var toEditIconPath: String?
    var toEditSubroutineIndex: IndexPath?
    
    var iconsArray = [String]()
    
    var selectedIndex: Int?
    var desc : String?
    
    // ---------------------
    // UI Actions
    // ---------------------
    @IBAction func descTextFieldEditing(_ sender: UITextField) {
        desc = sender.text
    }
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        popToRoutineDetailVC()
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        let saveIconURL : String?
        let saveDesc : String?

        if let selectedIndex = selectedIndex {
            saveIconURL = iconsArray[selectedIndex]
        } else {
            saveIconURL = nil
        }

        if let desc = desc {
            saveDesc = desc
        } else {
            saveDesc = nil
        }

        // adding new subroutine
        if (newSubroutineState!) {
            delegate?.addNewSubroutine(iconPath: saveIconURL, desc: saveDesc)
        }
        // editing existing subroutine
        else {
            guard let toEditSubroutineIndex = toEditSubroutineIndex else {
                print("Cannot find subroutine index for editing")
                return
            }
            delegate?.editExistingSubroutine(iconPath: saveIconURL, desc: saveDesc, at: toEditSubroutineIndex)
        }
        popToRoutineDetailVC()
    }
    
    private func popToRoutineDetailVC() {
        if let routineDetailVC = navigationController?.viewControllers[1] as? RoutineDetailViewController {
            navigationController?.popToViewController(routineDetailVC, animated: true)
        }
    }
    
    @IBAction func deleteSubroutineButtonTapped(_ sender: UIButton) {
        // if adding new subroutine, just go back
        if (newSubroutineState!) {
            popToRoutineDetailVC()
            return
        }
        
        // confirmation msg
        let deleteSubroutineAlert = UIAlertController(title: "Delete this subroutine?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        deleteSubroutineAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        deleteSubroutineAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
            guard let toEditSubroutineIndex = self.toEditSubroutineIndex else {
                print("Cannot find subroutine index for editing")
                return
            }
            
            self.delegate?.deleteSubroutine(at: toEditSubroutineIndex)
            self.popToRoutineDetailVC()
            
        }))
        self.present(deleteSubroutineAlert, animated: true, completion: nil)
        
        // if only 1 subroutine (auto init) -> not saved, so back
        // if only 1 subroutine (saved) -> remove subroutine, unwind
        
        // if 1+ subroutine, delete, switch to next in index.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempURLArray = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "Icons")! as [URL]
        // init sample icons from Icons Directory
        iconsArray = tempURLArray.map { url -> String in
            let theFileName = (url.path as NSString).lastPathComponent
            return theFileName
        }
        
        // If editing a subroutine
        if let newSubroutineState = newSubroutineState {
            
            if (!newSubroutineState) {
                descTextField.text = desc
                
                if let toEditIconPath = toEditIconPath {
                    selectedIndex = iconsArray.index(of: toEditIconPath)
                    availableIconsCollectionView.reloadData()
                }
                
            }
        }
        
        // Toggle save button
        if selectedIndex == nil {
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
        }
        
    
    }
        
    // ---------------------
    // Collection View
    // ---------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availableIconCell", for: indexPath) as! AvailableIconsCollectionViewCell
        
        // Remember to NOT write 'delegate?'
//        cell.delegate = self
        cell.cellIndex = indexPath.row
//        let cellIconImage = UIImage(named: iconsArray[indexPath.row])
        cell.setButtonImage(with: iconsArray[indexPath.row])

//        let editButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
//        editButton.setImage(UIImage(named: iconsArray[indexPath.row].path!), for: UIControlState.normal)
        
        // Change border of selected / deselected cells
        if cell.cellIndex == selectedIndex {
            cell.iconButton?.layer.borderColor = UIColor.red.cgColor
            cell.iconButton?.layer.borderWidth = 2
        } else {
//            cell.layer.borderColor = UIColor.cgColor
            cell.iconButton?.layer.borderWidth = 0
        }
        
//        cell.addSubview(editButton)
        return cell
    }
    
    func updateIfSaveButtonEnabled() {
        if selectedIndex == nil {
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // if same selection, deselect
        if selectedIndex == indexPath.row {
            selectedIndex = nil
        } else {
            selectedIndex = indexPath.row
        }
        
        updateIfSaveButtonEnabled()
    
        availableIconsCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: CGFloat(iconSize), height: CGFloat(iconSize))
    }
}
