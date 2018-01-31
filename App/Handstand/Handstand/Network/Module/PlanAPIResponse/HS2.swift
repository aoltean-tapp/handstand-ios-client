//
//  HS2.swift
//
//  Created by Ranjith Kumar on 12/12/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSSecondPlanListResponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kHS2SkuKey: String = "sku"
  private let kHS2PlanTextKey: String = "plan_text"
  private let kHS2InternalIdentifierKey: String = "id"
  private let kHS2TextKey: String = "text"
  private let kHS2ReebokActiveKey: String = "reebok_active"
  private let kHS2PlanDetailsKey: String = "plan_details"
  private let kHS2DurationKey: String = "duration"
  private let kHS2PriceKey: String = "price"

  // MARK: Properties
  public var sku: String?
  public var planText: String?
  public var internalIdentifier: Int?
  public var text: String?
  public var reebokActive: Bool = false
  public var planDetails: [HSPlanDetails]?
  public var duration: String?
  public var price: String?

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
    sku = json[kHS2SkuKey].string
    planText = json[kHS2PlanTextKey].string
    internalIdentifier = json[kHS2InternalIdentifierKey].int
    text = json[kHS2TextKey].string
    reebokActive = json[kHS2ReebokActiveKey].boolValue
    if let items = json[kHS2PlanDetailsKey].array { planDetails = items.map { HSPlanDetails(json: $0) } }
    duration = json[kHS2DurationKey].string
    price = json[kHS2PriceKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = sku { dictionary[kHS2SkuKey] = value }
    if let value = planText { dictionary[kHS2PlanTextKey] = value }
    if let value = internalIdentifier { dictionary[kHS2InternalIdentifierKey] = value }
    if let value = text { dictionary[kHS2TextKey] = value }
    dictionary[kHS2ReebokActiveKey] = reebokActive
    if let value = planDetails { dictionary[kHS2PlanDetailsKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = duration { dictionary[kHS2DurationKey] = value }
    if let value = price { dictionary[kHS2PriceKey] = value }
    return dictionary
  }

}
