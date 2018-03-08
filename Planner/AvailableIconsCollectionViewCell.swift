//
//  AvailableIconsCollectionViewCell.swift
//  Planner
//
//  Created by Edgar Yu on 3/6/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class AvailableIconsCollectionViewCell: UICollectionViewCell {
    var iconButton : UIButton?
//    var delegate : ChooseIconDelegate?
    var cellIndex : Int?
    
    func setButtonImage(with image: UIImage) {
//        availableIcon?.addTarget(self, action: #selector(selectIconButtonTapped), for: UIControlEvents.touchUpInside)
        
//        availableIcon?.setImage(UIImage(named: imageURL), for: UIControlState.normal)
        
        if iconButton == nil {
            iconButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
            iconButton?.isUserInteractionEnabled = false
            iconButton?.maskAsCircle()
            
            self.addSubview(iconButton!)
        }
        iconButton?.setImage(image, for: UIControlState.normal)
    }
    
    
}
