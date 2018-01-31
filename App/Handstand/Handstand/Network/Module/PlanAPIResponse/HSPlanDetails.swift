//
//  HSPlanDetails.swift
//
//  Created by Ranjith Kumar on 12/12/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSPlanDetails {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHSPlanDetailsTextKey: String = "text"
  private let kHSPlanDetailsValueKey: String = "value"

  // MARK: Properties
  public var text: String?
  public var value: Bool = false

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    text = json[kHSPlanDetailsTextKey].string
    value = json[kHSPlanDetailsValueKey].boolValue
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = text { dictionary[kHSPlanDetailsTextKey] = value }
    dictionary[kHSPlanDetailsValueKey] = value
    return dictionary
  }

}
