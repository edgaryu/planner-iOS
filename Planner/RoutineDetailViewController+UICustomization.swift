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
        // Constants
        // ---------------------
        
        let headerHeight : Int = 30
        
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
//        userView.layer.backgroundColor = UIColor.lightGray.cgColor
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
            make.height.equalTo(headerHeight)
            make.top.left.right.equalTo(userView)
        }

        subroutineHeaderView.addSubview(addSubroutineButton)
        addSubroutineButton.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(headerHeight)
            make.top.right.bottom.equalTo(subroutineHeaderView)
        }

        subroutineHeaderView.addSubview(editSubroutineButton)
        editSubroutineButton.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(headerHeight)
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
        iconsContainerView.layer.borderWidth = 0.5
        iconsContainerView.layer.borderColor = UIColor.lightGray.cgColor
//        iconsContainerView.layer.cornerRadius = 5
        iconsContainerView.snp.makeConstraints { (make) in
            make.height.equalTo(iconSize + 16)
            make.top.equalTo(subroutineHeaderView.snp.bottom).offset(0)
//            make.top.equalTo(iconsContainerView.superview!)
            make.left.right.equalTo(iconsContainerView.superview!)
        }

        
        userView.addSubview(descTextLabelView)
        descTextLabelView.layer.borderWidth = 0.5
        descTextLabelView.layer.borderColor = UIColor.lightGray.cgColor
        descTextLabelView.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(iconsContainerView.snp.bottom).offset(0)
            make.left.right.equalTo(descTextLabelView.superview!)
        }
        descTextLabelView.addSubview(descTextLabel)
        descTextLabel.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(descTextLabel.superview!)
        }
        
        // in actions view
        userView.addSubview(actionsView)
        actionsView.layer.borderWidth = 0.5
        actionsView.layer.borderColor = UIColor.lightGray.cgColor
        actionsView.snp.makeConstraints { (make) in
            make.top.equalTo(descTextLabelView.snp.bottom).offset(15)
            make.left.right.bottom.equalTo(actionsView.superview!)
        }
        
        actionsView.addSubview(addActionView)
        addActionView.layer.borderWidth = 1
        addActionView.layer.borderColor = UIColor.lightGray.cgColor
        addActionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(addActionView.superview!)
            make.height.equalTo(headerHeight)
        }
        
        actionTextField.attributedPlaceholder = NSAttributedString(string:"Add a new action", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        addActionView.addSubview(addActionStackView)
        addActionStackView.snp.makeConstraints { (make) in
            make.left.equalTo(addActionStackView.superview!).offset(20)
            make.right.equalTo(addActionStackView.superview!).offset(-20)
            make.top.bottom.equalTo(addActionStackView.superview!)
        }
        
        // bottom nav
        actionsView.addSubview(editStackView)
        editStackView.snp.makeConstraints { (make) in
            make.right.equalTo(editStackView.superview!).offset(-10)
            make.bottom.equalTo(editStackView.superview!).offset(-10)
        }
        
        actionsView.addSubview(weatherStackVIew)
        weatherStackVIew.snp.makeConstraints { (make) in
            make.left.equalTo(weatherStackVIew.superview!).offset(10)
            make.bottom.equalTo(weatherStackVIew.superview!).offset(-10)
        }
        
//        actionsView.addSubview(editActionsButton)
//        editActionsButton.layer.borderWidth = 1
//        editActionsButton.layer.borderColor = UIColor.orange.cgColor
        editActionsButton.snp.makeConstraints { (make) in
            make.right.equalTo(editActionsButton.superview!).offset(-10)
            make.bottom.equalTo(editActionsButton.superview!).offset(-10)
        }
        
//        actionsView.addSubview(weatherButton)
//        weatherButton.layer.borderWidth = 1
//        weatherButton.layer.borderColor = UIColor.orange.cgColor
//        weatherButton.snp.makeConstraints { (make) in
//            make.left.equalTo(weatherButton.superview!).offset(10)
//            make.bottom.equalTo(weatherButton.superview!).offset(-10)
//        }
        
        actionsView.addSubview(actionsContainerView)
        actionsContainerView.layer.borderWidth = 0.5
        actionsContainerView.layer.borderColor = UIColor.red.cgColor
        actionsContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(addActionStackView.snp.bottom).offset(10)
            make.left.right.equalTo(actionsContainerView.superview!)
//            make.bottom.equalTo(editActionsButton.snp.top).offset(-15)
            make.bottom.equalTo(editStackView.snp.top).offset(-10)
        }
    }
}
