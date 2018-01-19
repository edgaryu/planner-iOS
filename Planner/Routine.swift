//
//  Routine.swift
//  Planner
//
//  Created by Edgar Yu on 1/14/18.
//  Copyright © 2018 AppleInc. All rights reserved.
//

import Foundation

struct Routine : Codable {
    var routineTitle: String
    var actions : [Action]
    
    // storage URL of app data
    static var archiveURL : URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("planner").appendingPathExtension("plist")
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
            print(error)
            return [Routine]()
        }
    }
    
}
