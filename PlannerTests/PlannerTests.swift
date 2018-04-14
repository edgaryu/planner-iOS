//
//  PlannerTests.swift
//  PlannerTests
//
//  Created by Edgar Yu on 1/18/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import XCTest
@testable import Planner

class PlannerTests: XCTestCase {
    var listvc : RoutineListViewController!
    var dummyRoutines: [Routine]?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navvc = storyboard.instantiateViewController(withIdentifier: "nav1") as! UINavigationController
        listvc = navvc.viewControllers[0] as! RoutineListViewController
        let _ = listvc.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        listvc = nil
        dummyRoutines = nil
        super.tearDown()
    }
    
    func startWithEmptyRoutines() {
        listvc.routines.removeAll()
        XCTAssert(listvc.routines.count == 0, "Listvc routine array not empty")
    }
    
    func startWithDummyRoutines() {
        startWithEmptyRoutines()
        let action1 = Action(actionTitle: "Eat breakfast", completed: false)
        let action2 = Action(actionTitle: "Eat dinner", completed: true)
        let action3 = Action(actionTitle: "Brush teeth", completed: false)
        let Routine1 = Routine(routineTitle: "Eat foods", actions: [action1, action2])
        let Routine2 = Routine(routineTitle: "Morning hygiene", actions: [action3])
        let Routine3 = Routine(routineTitle: "Empty Routine", actions: [Action]())
        dummyRoutines = [Routine1, Routine2, Routine3]
        
        if let dummyRoutines = dummyRoutines {
            listvc.routines = dummyRoutines
        } else {
            print("Issue with starting with dummy routines")
            return
        }
        XCTAssert(listvc.routines.count == 3, "Wrong amount of routines in listvc")
    }
    
    // Checks if the supplied routine array corresponds with the data presented in the table view in RoutineListTableViewController
    func testRoutineArrayCorrespondsWithRoutineListTV() {
        // Check RoutineListTableView behavior when routines are empty
        startWithEmptyRoutines()
        let numOfRowsEmpty = listvc.tableView(listvc.tableView, numberOfRowsInSection: 0)
        XCTAssert(numOfRowsEmpty == 0, "Empty routine array yields incorrect # of rows")
        
        // Check RoutineListTableView behavior when routines are not empty
        startWithDummyRoutines()
        let numOfRows = listvc.tableView(listvc.tableView, numberOfRowsInSection: 0)
        XCTAssert(numOfRows == dummyRoutines!.count, "Nonempty routine array (\(dummyRoutines!.count) yields incorrect # of rows (\(numOfRows)")
        
        // Check correct routineTitle and # of actions
        for routinePosition in 0 ..< dummyRoutines!.count {
            let routineCell = listvc.tableView(listvc.tableView, cellForRowAt: IndexPath(row: routinePosition, section: 0))
            XCTAssert(routineCell.textLabel?.text == dummyRoutines![routinePosition].routineTitle, "Routine \(routinePosition)'s titles do not match")
            XCTAssert(routineCell.detailTextLabel?.text == "\(dummyRoutines![routinePosition].actions.count) actions", "Routine \(routinePosition)'s actions count does not match")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
