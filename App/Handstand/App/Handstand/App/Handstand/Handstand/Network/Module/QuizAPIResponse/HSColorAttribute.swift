//
//  HSColorAttribute.swift
//
//  Created by Ranjith Kumar on 12/12/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSColorAttribute {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHSColorAttributeNameKey: String = "name"
  private let kHSColorAttributeCodeKey: String = "code"

  // MARK: Properties
  public var name: String?
  public var code: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    name = json[kHSColorAttributeNameKey].string
    code = json[kHSColorAttributeCodeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kHSColorAttributeNameKey] = value }
    if let value = code { dictionary[kHSColorAttributeCodeKey] = value }
    return dictionary
  }

}
