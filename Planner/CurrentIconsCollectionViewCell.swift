//
//  CurrentIconsCollectionViewCell.swift
//  Planner
//
//  Created by Edgar Yu on 3/11/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class CurrentIconsCollectionViewCell: UICollectionViewCell {
    var iconButton : UIButton?
    //    var delegate : ChooseIconDelegate?
    var cellIndex : Int?
    var iconImage : UIImageView?
    
    func setButtonImage(with iconPath: String) {
        //        availableIcon?.addTarget(self, action: #selector(selectIconButtonTapped), for: UIControlEvents.touchUpInside)
        
        //        availableIcon?.setImage(UIImage(named: imageURL), for: UIControlState.normal)
        
        if iconButton == nil {
            iconButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
            iconButton?.isUserInteractionEnabled = false
            iconButton?.maskAsCircle()
            
            self.addSubview(iconButton!)
        }
        let buttonImg = UIImage(named: iconPath)
        iconButton?.setImage(buttonImg, for: UIControlState.normal)
    }
    
//    func setIconImage(with iconPath: String) {
//        if iconImage == nil {
//            iconImage = UIImageView()
//            iconImage?.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
//            iconImage?.maskAsCircle()
//            
//            self.addSubview(iconImage!)
//            
//        }
//        iconImage?.image = UIImage(named: iconPath)
//    }
}

