//
//  HTSpecialities.swift
//
//  Created by Navjot Sharma on 18/12/17
//  Copyright (c) HandstandTrainer. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSSpecialities {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let id = "id"
    static let name = "name"
  }

  // MARK: Properties
  public var id: Int?
  public var name: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    id = json[SerializationKeys.id].int
    name = json[SerializationKeys.name].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    return dictionary
  }

}
