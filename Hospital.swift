//
//  Hospital.swift
//  VacCalc
//
//  Created by Sumrudhi Jadhav on 11/22/20.
//  Copyright © 2020 CATS. All rights reserved.
//

import UIKit
import os.log

class Hospital: NSObject, NSCoding {
    
    
    
    // MARK: Properties
    
    var name: String
    var inStock: String
    var needed: String
    var photo: UIImage?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for:.documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("hospitals")
    
    // MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let inStock = "in stock"
        static let needed = "needed"
        static let photo = "photo"
    }
    
    // MARK: Initialization
    
    init?(name: String, inStock: String, needed: String, photo: UIImage?){
        
        // The strings must not be empty
        guard !name.isEmpty && !inStock.isEmpty && !needed.isEmpty else{
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.inStock = inStock
        self.needed = needed
        self.photo = photo
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(inStock, forKey: PropertyKey.inStock)
        aCoder.encode(needed, forKey: PropertyKey.needed)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The strings are required. If we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Hospital object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let inStock = aDecoder.decodeObject(forKey: PropertyKey.inStock) as? String else {
            os_log("Unable to decode the amount of vaccines in stock for a Hospital object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let needed = aDecoder.decodeObject(forKey: PropertyKey.needed) as? String else {
            os_log("Unable to decode the amount of vaccines needed for a Hospital object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Hospital, just use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Must call designated initializer
        self.init(name: name, inStock: inStock, needed: needed, photo: photo)
        
    }
    
}
