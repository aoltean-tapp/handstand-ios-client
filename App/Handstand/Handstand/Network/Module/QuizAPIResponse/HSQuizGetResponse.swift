//
//  HSQuizGetResponse.swift
//
//  Created by Ranjith Kumar on 12/14/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSQuizGetResponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHSQuizGetResponseResultKey: String = "result"
  private let kHSQuizGetResponseQuizKey: String = "quiz"

  // MARK: Properties
  public var result: String?
  public var quiz: [HSQuiz]?

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
    result = json[kHSQuizGetResponseResultKey].string
    if let items = json[kHSQuizGetResponseQuizKey].array { quiz = items.map { HSQuiz(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = result { dictionary[kHSQuizGetResponseResultKey] = value }
    if let value = quiz { dictionary[kHSQuizGetResponseQuizKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
