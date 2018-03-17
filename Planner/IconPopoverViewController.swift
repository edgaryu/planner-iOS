//
//  IconPopoverViewController.swift
//  Planner
//
//  Created by Edgar Yu on 3/13/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

protocol IconPopoverDelegate : class {
    func editSubroutine(at indexPath: IndexPath)
    func deleteSubroutine(at indexPath: IndexPath)
}

class IconPopoverViewController: UIViewController {
    
    var delegate: IconPopoverDelegate?
    var cellIndexPath : IndexPath?
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if let cellIndexPath = cellIndexPath {
            delegate?.editSubroutine(at: cellIndexPath)
        }
        
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let cellIndexPath = cellIndexPath {
            delegate?.deleteSubroutine(at: cellIndexPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
