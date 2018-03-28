//
//  Routine.swift
//  Planner
//
//  Created by Edgar Yu on 1/14/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import Foundation
import UIKit

let dataFilePath = "planner_v2"

struct Routine : Codable {
    var routineTitle: String
    var subroutines : [Subroutine]
    
    // storage URL of app data
    static var archiveURL : URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(dataFilePath).appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveToFile(routines: [Routine]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedRoutines = try? propertyListEncoder.encode(routines)
        
        do {
            try encodedRoutines?.write(to: Routine.archiveURL, options: .noFileProtection)
        }
        catch {
            print(error)
        }
    }
    
    static func loadFromFile() -> [Routine] {
        let propertyListDecoder = PropertyListDecoder()

        do {
            let retrieveData = try Data(contentsOf: archiveURL)
            return try propertyListDecoder.decode(Array<Routine>.self, from: retrieveData)
        } catch {
//            print(error)
            return [Routine]()
        }
    }
    
    static func emptyRoutines() -> [Routine] {
        return [Routine]()
    }
    
}

struct Subroutine : Codable {
    var iconPath : String?
    var desc : String?
    var actions : [Action]
    
    // initialize completely empty subroutine at this index
    // default icon is
    init(at index: Int) {
        iconPath = "001-clouded.png"
        desc = nil
        actions = [Action]()
    }
    
    // only iconURL and desc available for init
    init(newIconPath: String?, newDesc: String?) {
        if let newIconPath = newIconPath {
            iconPath = newIconPath
        } else {
            iconPath = nil
        }
        
        if let newDesc = newDesc {
            desc = newDesc
        } else {
            desc = nil
        }
        
        actions = [Action]()
    }
    
}
