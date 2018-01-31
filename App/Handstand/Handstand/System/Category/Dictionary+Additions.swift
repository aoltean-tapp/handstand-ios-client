//
//  Dictionary+Additions.swift
//  ADDO
//
//  Created by Ranjith Kumar on 15/03/2017.
//  Copyright © 2017 F22 LABS. All rights reserved.
//

import Foundation


//: ### Subscript Solution
//: We create a special subscript for nested `[String:Any]` dictionaries that also has a getter:

extension Dictionary {
    
    subscript(jsonDict key: Key) -> [String:Any]? {
        get {
            return self[key] as? [String:Any]
        }
    }
    
    subscript(string key: Key) -> String? {
        get {
            return self[key] as? String
        }
    }
    
    subscript(int key: Key) -> Int? {
        get {
            return self[key] as? Int
        }
    }
    
    subscript(bool key: Key) -> Bool? {
        get {
            return self[key] as? Bool
        }
    }
    
    subscript(double key: Key) -> Double? {
        get {
            return self[key] as? Double
        }
    }
    
    subscript(float key: Key) -> Float? {
        get {
            return self[key] as? Float
        }
    }
    
    
}
