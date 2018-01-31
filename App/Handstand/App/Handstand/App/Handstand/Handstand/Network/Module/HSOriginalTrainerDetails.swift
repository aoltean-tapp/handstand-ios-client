//
//  HSOriginalTrainerDetails.swift
//
//  Created by Ranjith Kumar on 11/3/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSOriginalTrainerDetails {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHSOriginalTrainerDetailsTrainerThumbnailKey: String = "trainer_thumbnail"
  private let kHSOriginalTrainerDetailsTrainerClasstypeKey: String = "trainer_classtype"
  private let kHSOriginalTrainerDetailsTrainerIdKey: String = "trainer_id"
  private let kHSOriginalTrainerDetailsTrainerAvatarKey: String = "trainer_avatar"
  private let kHSOriginalTrainerDetailsTrainerFirstnameKey: String = "trainer_firstname"
  private let kHSOriginalTrainerDetailsTrainerLocationKey: String = "trainer_location"

  // MARK: Properties
  public var trainerThumbnail: String?
  public var trainerClasstype: String?
  public var trainerId: Int?
  public var trainerAvatar: String?
  public var trainerFirstname: String?
  public var trainerLocation: String?

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
    trainerThumbnail = json[kHSOriginalTrainerDetailsTrainerThumbnailKey].string
    trainerClasstype = json[kHSOriginalTrainerDetailsTrainerClasstypeKey].string
    trainerId = json[kHSOriginalTrainerDetailsTrainerIdKey].int
    trainerAvatar = json[kHSOriginalTrainerDetailsTrainerAvatarKey].string
    trainerFirstname = json[kHSOriginalTrainerDetailsTrainerFirstnameKey].string
    trainerLocation = json[kHSOriginalTrainerDetailsTrainerLocationKey].string
    
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = trainerThumbnail { dictionary[kHSOriginalTrainerDetailsTrainerThumbnailKey] = value }
    if let value = trainerClasstype { dictionary[kHSOriginalTrainerDetailsTrainerClasstypeKey] = value }
    if let value = trainerId { dictionary[kHSOriginalTrainerDetailsTrainerIdKey] = value }
    if let value = trainerAvatar { dictionary[kHSOriginalTrainerDetailsTrainerAvatarKey] = value }
    if let value = trainerFirstname { dictionary[kHSOriginalTrainerDetailsTrainerFirstnameKey] = value }
    if let value = trainerLocation { dictionary[kHSOriginalTrainerDetailsTrainerLocationKey] = value }
    return dictionary
  }

}


