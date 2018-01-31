//
//  HS0.swift
//
//  Created by Ranjith Kumar on 12/12/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSZerothPlanListResponse:PlanListResponse {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHS0SkuKey: String = "sku"
    private let kHS0PlanTextKey: String = "plan_text"
    private let kHS0InternalIdentifierKey: String = "id"
    private let kHS0TextKey: String = "text"
    private let kHS0ReebokActiveKey: String = "reebok_active"
    private let kHS0PlanDetailsKey: String = "plan_details"
    private let kHS0DurationKey: String = "duration"
    private let kHS0PriceKey: String = "price"
    
    // MARK: Properties
    public var sku: String?
    public var planText: String?
    public var internalIdentifier: Int?
    public var text: String?
    public var reebokActive: Bool = false
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
    public convenience init(json: JSON) {
        self.init()
        sku = json[kHS0SkuKey].string
        planText = json[kHS0PlanTextKey].string
        internalIdentifier = json[kHS0InternalIdentifierKey].int
        text = json[kHS0TextKey].string
        reebokActive = json[kHS0ReebokActiveKey].boolValue
        if let items = json[kHS0PlanDetailsKey].array { self.planDetails = items.map { HSPlanDetails(json: $0) } }
        duration = json[kHS0DurationKey].string
        price = json[kHS0PriceKey].string
        self.isSelected = true
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = sku { dictionary[kHS0SkuKey] = value }
        if let value = planText { dictionary[kHS0PlanTextKey] = value }
        if let value = internalIdentifier { dictionary[kHS0InternalIdentifierKey] = value }
        if let value = text { dictionary[kHS0TextKey] = value }
        dictionary[kHS0ReebokActiveKey] = reebokActive
        if let value = planDetails { dictionary[kHS0PlanDetailsKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = duration { dictionary[kHS0DurationKey] = value }
        if let value = price { dictionary[kHS0PriceKey] = value }
        return dictionary
    }
    
}
