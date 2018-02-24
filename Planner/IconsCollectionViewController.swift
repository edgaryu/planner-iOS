//
//  IconsCollectionViewController.swift
//  Planner
//
//  Created by Edgar Yu on 2/22/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

let iconSize = 50

protocol IconsContainerDelegate: class {
    func updateIcons(with newIcons: [UIColor])
}

class IconsCollectionViewController: UICollectionViewController {
    
    var icons = [UIColor]()
    var delegate : IconsContainerDelegate?
    
    

    // Delegate method
    @objc func addIconButtonTapped() {
        // popup box
        let addColorAlert = UIAlertController(title: "Add new color", message: "", preferredStyle: UIAlertControllerStyle.alert)
        addColorAlert.addTextField { (textField) in
            textField.text = ""
        }
        addColorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        addColorAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { action in
            guard let newColor =  addColorAlert.textFields?.first!.text else {
                print("Add new color error")
                return
            }
            var varColor : UIColor
            switch(newColor) {
            case "red":
                varColor = UIColor.red
                break
            case "blue":
                varColor = UIColor.blue
                break
            case "green":
                varColor = UIColor.green
                break
            default:
                varColor = UIColor.black
                break
            }
            self.icons.append(varColor)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.delegate?.updateIcons(with: self.icons)
            }
            
        }))
        self.present(addColorAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return icons.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // last collectionViewCell is the add button
        if (indexPath.row == icons.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addIconCell", for: indexPath)
            
            let editButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
            editButton.setImage(UIImage(named: "icons8-plus-math-40"), for: UIControlState.normal)
            editButton.addTarget(self, action: #selector(addIconButtonTapped), for: UIControlEvents.touchUpInside)
            cell.contentView.addSubview(editButton)
            
            // customize cell
            cell.maskAsCircle()
            
            return cell
        }
        // icon collection cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath)
        
        // customize cell
        cell.maskAsCircle()
        cell.contentView.backgroundColor = icons[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let itemsPerRow:CGFloat = 4
        //        let hardCodedPadding:CGFloat = 5
        //        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        //        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
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

extension UICollectionViewCell {
    func maskAsCircle() {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
