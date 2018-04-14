//
//  RoutineDetailViewController+UICustomization.swift
//  Planner
//
//  Created by Edgar Yu on 3/7/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import Foundation
import UIKit

extension RoutineDetailViewController {
    func updateUI() {
        
        // ---------------------
        // Constraint layouts
        // ---------------------
        
        self.view.addSubview(bottomBackgroundView)
//        bottomBackgroundView.layer.backgroundColor = UIColor.lightGray.cgColor
        bottomBackgroundView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(0)
            make.height.equalTo(self.view.frame.size.height/2)
        }
        
        self.view.addSubview(userView)
        userView.layer.backgroundColor = UIColor.lightGray.cgColor
//        userView.layer.borderWidth = 0.5
//        userView.layer.borderColor = UIColor.lightGray.cgColor
        userView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(15)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-15)
        }
        
        userView.addSubview(subroutineHeaderView)
        subroutineHeaderView.layer.borderWidth = 1
        subroutineHeaderView.layer.borderColor = UIColor.lightGray.cgColor
        subroutineHeaderView.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.top.left.right.equalTo(userView)
        }

        subroutineHeaderView.addSubview(addSubroutineButton)
        addSubroutineButton.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(25)
            make.top.right.bottom.equalTo(subroutineHeaderView)
        }

        subroutineHeaderView.addSubview(editSubroutineButton)
        editSubroutineButton.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(25)
            make.top.bottom.equalTo(subroutineHeaderView)
            make.right.equalTo(addSubroutineButton.snp.left)
        }

        subroutineHeaderView.addSubview(subroutineHeaderLabel)
        subroutineHeaderLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(subroutineHeaderView)
            make.left.equalTo(subroutineHeaderView).offset(10)
//            make.right.equalTo(editSubroutineButton.snp.left)
        }
        
        userView.addSubview(iconsContainerView)
//        iconsContainerView.layer.backgroundColor = UIColor(white: 1, alpha: 0.0).cgColor
//        iconsContainerView.layer.borderWidth = 1
//        iconsContainerView.layer.borderColor = UIColor.red.cgColor
//        iconsContainerView.layer.cornerRadius = 5
        iconsContainerView.snp.makeConstraints { (make) in
            make.height.equalTo(iconSize + 16)
            make.top.equalTo(subroutineHeaderView.snp.bottom).offset(0)
//            make.top.equalTo(iconsContainerView.superview!)
            make.left.right.equalTo(iconsContainerView.superview!)
        }
        
//        let addIconButton = UIButton(frame: CGRect(x:0, y:0, width: iconSize, height: iconSize))
//        addIconButton.setImage(UIImage(named: "017-edit"), for: .normal)
////        addIconButton.maskAsCircle()
//        userView.addSubview(addIconButton)
//        addIconButton.snp.makeConstraints { (make) in
//            make.top.bottom.equalTo(iconsContainerView)
//            make.right.equalTo(userView).offset(0)
//        }
        
        userView.addSubview(descTextLabelView)
        descTextLabelView.layer.borderWidth = 1
        descTextLabelView.layer.borderColor = UIColor.blue.cgColor
        descTextLabelView.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.top.equalTo(iconsContainerView.snp.bottom).offset(0)
            make.left.right.equalTo(descTextLabelView.superview!)
        }
        descTextLabelView.addSubview(descTextLabel)
        descTextLabel.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(descTextLabel.superview!)
        }
        
        // in actions view
        userView.addSubview(actionsView)
        actionsView.layer.borderWidth = 1
        actionsView.layer.borderColor = UIColor.purple.cgColor
        actionsView.snp.makeConstraints { (make) in
            make.top.equalTo(descTextLabelView.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(actionsView.superview!)
        }
        
        
        actionsView.addSubview(addActionStackView)
        //        addActionStackView.layer.borderWidth = 1
        //        addActionStackView.layer.borderColor = UIColor.orange.cgColor
        addActionStackView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(addActionStackView.superview!)
        }
        
        // bottom nav
        actionsView.addSubview(editActionsButton)
        editActionsButton.layer.borderWidth = 1
        editActionsButton.layer.borderColor = UIColor.orange.cgColor
        editActionsButton.snp.makeConstraints { (make) in
            make.right.equalTo(editActionsButton.superview!).offset(-8)
            make.bottom.equalTo(editActionsButton.superview!).offset(-8)
        }
        
        actionsView.addSubview(weatherButton)
        weatherButton.layer.borderWidth = 1
        weatherButton.layer.borderColor = UIColor.orange.cgColor
        weatherButton.snp.makeConstraints { (make) in
            make.left.equalTo(weatherButton.superview!).offset(8)
            make.bottom.equalTo(weatherButton.superview!).offset(-8)
        }
        
        actionsView.addSubview(actionsContainerView)
        actionsContainerView.layer.borderWidth = 2
        actionsContainerView.layer.borderColor = UIColor.red.cgColor
        actionsContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(addActionStackView.snp.bottom).offset(16)
            make.left.right.equalTo(actionsContainerView.superview!)
            make.bottom.equalTo(editActionsButton.snp.top).offset(-8)
        }
    }
}
