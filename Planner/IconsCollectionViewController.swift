//
//  IconsCollectionViewController.swift
//  Planner
//
//  Created by Edgar Yu on 2/22/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

let iconSize = 50
let popoverWidth = 50
let popoverHeight = 50

protocol IconsContainerDelegate: class {
    func reloadRoutineDetailVC()
    func updateCurrentSubroutine(with newSubIndex: Int)
}

class IconsCollectionViewController: UICollectionViewController  {
    
    var delegate : IconsContainerDelegate?
    var subroutines = [Subroutine]()
    var selectedIndex = 0
    
    // Delegate functions
    
//    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
//        if (gestureRecognizer.state != UIGestureRecognizerState.began){
//            return
//        }
//        let p = gestureRecognizer.location(in: self.collectionView)
//        if let indexPath : IndexPath = (self.collectionView?.indexPathForItem(at: p)){
//
//            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let popoverController = storyboard.instantiateViewController(withIdentifier: "iconPopover")
//                as! IconPopoverViewController
//            popoverController.modalPresentationStyle = UIModalPresentationStyle.popover
//            popoverController.delegate = self
//            popoverController.cellIndexPath = indexPath
//
//
//            if let popover: UIPopoverPresentationController =
//                popoverController.popoverPresentationController {
//                let sourceView = self.collectionView?.cellForItem(at: indexPath)
//                popover.delegate = self
//                popover.permittedArrowDirections = .up
//                popoverController.preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
//                //            popover.backgroundColor = popoverController.view.backgroundColor
//                popover.sourceView = sourceView
//                popover.sourceRect = sourceView!.bounds
//            }
//            present(popoverController, animated: true, completion: nil)
//        }
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
//        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
//        lpgr.minimumPressDuration = 0.5
//        lpgr.delegate = self
//        lpgr.delaysTouchesBegan = true
//        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subroutines.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currentIconCell", for: indexPath) as! CurrentIconsCollectionViewCell
        cell.cellIndex = indexPath.row
        
        if let iconPath = subroutines[indexPath.row].iconPath {
            cell.setButtonImage(with: iconPath)
        }

        // Change border of selected / deselected cells
        if cell.cellIndex == selectedIndex {
            cell.iconButton?.layer.borderColor = UIColor.green.cgColor
            cell.iconButton?.layer.borderWidth = 4
        } else {
//            cell.layer.borderColor = UIColor.cgColor
            cell.iconButton?.layer.borderWidth = 0
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell1 = self.collectionView?.cellForItem(at: indexPath) as! CurrentIconsCollectionViewCell
//        print("\(indexPath.row), \(cell1.cellIndex)")
//        self.collectionView?.cellForItem(at: indexPath.row)
        
        // return if selected last cell or if selected same index
        if (selectedIndex == indexPath.row || indexPath.row == subroutines.count) {
            return
        }
        
        // else, change selectedIndex, reload iconsCollection, then call delegate to reload actionsTVC and desc
        selectedIndex = indexPath.row
        delegate?.updateCurrentSubroutine(with: selectedIndex)
        delegate?.reloadRoutineDetailVC()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(iconSize), height: CGFloat(iconSize))
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
