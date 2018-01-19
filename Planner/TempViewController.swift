//
//  TempViewController.swift
//  Planner
//
//  Created by Edgar Yu on 1/17/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    var vc3 = TempTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTableSegue" {
            let vc3 = segue.destination as! TempTableViewController
            vc3.hello = "Hello"
        }
    }

}
