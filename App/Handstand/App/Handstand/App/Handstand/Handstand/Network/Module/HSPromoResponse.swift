//
//  HSPromoResponse.swift
//
//  Created by Ranjith Kumar on 9/1/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSPromoResponse {
    
    static let discountPriceTypeKey:String = "PRICE"
    static let discountPercentageTypeKey:String = "PERCENTAGE"

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHSPromoResponseDiscountTypeKey: String = "discountType"
  private let kHSPromoResponseDiscountValueKey: String = "discountValue"
  private let kHSPromoResponseMessageKey: String = "message"
  private let kHSPromoResponseResultKey: String = "result"

  // MARK: Properties
  public var discountType: String?
  public var discountValue: Int?
  public var message: String?
  public var result: String?

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
    discountType = json[kHSPromoResponseDiscountTypeKey].string
    discountValue = json[kHSPromoResponseDiscountValueKey].int
    message = json[kHSPromoResponseMessageKey].string
    result = json[kHSPromoResponseResultKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = discountType { dictionary[kHSPromoResponseDiscountTypeKey] = value }
    if let value = discountValue { dictionary[kHSPromoResponseDiscountValueKey] = value }
    if let value = message { dictionary[kHSPromoResponseMessageKey] = value }
    if let value = result { dictionary[kHSPromoResponseResultKey] = value }
    return dictionary
  }

}
