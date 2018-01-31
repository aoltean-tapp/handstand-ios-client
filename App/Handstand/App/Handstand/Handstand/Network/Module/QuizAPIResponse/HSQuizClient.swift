//
//  HSQuizClient.swift
//
//  Created by Ranjith Kumar on 12/14/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSQuizClient {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHSClientHeaderKey: String = "header"
  private let kHSClientQuizKey: String = "quiz"

  // MARK: Properties
  public var header: String?
  public var quiz: String?

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
    header = json[kHSClientHeaderKey].string
    quiz = json[kHSClientQuizKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = header { dictionary[kHSClientHeaderKey] = value }
    if let value = quiz { dictionary[kHSClientQuizKey] = value }
    return dictionary
  }

}
