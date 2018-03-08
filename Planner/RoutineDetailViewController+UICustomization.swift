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
        // actionsContainer
        actionsContainerView.layer.borderWidth = 1
        actionsContainerView.layer.borderColor = UIColor.black.cgColor
        //        deleteRoutineButton.layer.cornerRadius = 5
        
        // iconsContainer
        iconsContainerView.layer.borderWidth = 1
        iconsContainerView.layer.borderColor = UIColor.lightGray.cgColor
        iconsContainerView.layer.cornerRadius = 5
        
        
        self.view.addSubview(bottomBackgroundView)
        bottomBackgroundView.layer.backgroundColor = UIColor.lightGray.cgColor
        bottomBackgroundView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(0)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(0)
            make.height.equalTo(self.view.frame.size.height/2)
        }
        
        self.view.addSubview(userView)
        userView.layer.borderWidth = 0.5
        userView.layer.borderColor = UIColor.lightGray.cgColor
        userView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(24)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-24)
        }
        
        userView.addSubview(iconsContainerView)
        iconsContainerView.layer.borderWidth = 2
        iconsContainerView.layer.borderColor = UIColor.red.cgColor
        iconsContainerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(iconsContainerView.superview!)
        }
        
        userView.addSubview(descTextLabel)
        descTextLabel.layer.borderWidth = 1
        descTextLabel.layer.borderColor = UIColor.blue.cgColor
        descTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconsContainerView.snp.bottom).offset(16)
            make.left.right.equalTo(descTextLabel.superview!)
        }
        
        userView.addSubview(actionsView)
        actionsView.layer.borderWidth = 0.75
        actionsView.layer.borderColor = UIColor.green.cgColor
        actionsView.snp.makeConstraints { (make) in
            make.top.equalTo(descTextLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalTo(actionsView.superview!)
        }
        
        // in actions view
        actionsView.addSubview(addActionStackView)
        //        addActionStackView.layer.borderWidth = 1
        //        addActionStackView.layer.borderColor = UIColor.orange.cgColor
        addActionStackView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(addActionStackView.superview!)
        }
        
        userView.addSubview(editActionsButton)
        editActionsButton.layer.borderWidth = 1
        editActionsButton.layer.borderColor = UIColor.orange.cgColor
        editActionsButton.snp.makeConstraints { (make) in
            make.right.equalTo(editActionsButton.superview!).offset(-8)
            make.bottom.equalTo(editActionsButton.superview!).offset(-8)
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
