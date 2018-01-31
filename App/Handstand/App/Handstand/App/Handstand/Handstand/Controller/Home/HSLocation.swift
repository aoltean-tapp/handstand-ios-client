//
//  HSLocation.swift
//
//  Created by Ranjith Kumar on 11/28/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSLocation {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHSLocationLongitudeKey: String = "longitude"
  private let kHSLocationLatidudeKey: String = "latidude"

  // MARK: Properties
  public var longitude: Float?
  public var latidude: Float?

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
    longitude = json[kHSLocationLongitudeKey].float
    latidude = json[kHSLocationLatidudeKey].float
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = longitude { dictionary[kHSLocationLongitudeKey] = value }
    if let value = latidude { dictionary[kHSLocationLatidudeKey] = value }
    return dictionary
  }

}
