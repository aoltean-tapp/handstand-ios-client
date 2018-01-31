//
//  HTData.swift
//
//  Created by Navjot Sharma on 18/12/17
//  Copyright (c) HandstandTrainer. All rights reserved.
//

import Foundation
import  SwiftyJSON

public struct HSSpecialitiesData {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let specialities = "specialities"
  }

  // MARK: Properties
  public var specialities: [HSSpecialities]?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    if let items = json[SerializationKeys.specialities].array { specialities = items.map { HSSpecialities(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = specialities { dictionary[SerializationKeys.specialities] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
