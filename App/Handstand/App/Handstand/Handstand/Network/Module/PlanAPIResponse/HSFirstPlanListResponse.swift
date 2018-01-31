//
//  HS1.swift
//
//  Created by Ranjith Kumar on 12/12/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSFirstPlanListResponse:PlanListResponse {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHS1PackageIdKey: String = "package_id"
    private let kHS1InternalIdentifierKey: String = "id"
    private let kHS1TextKey: String = "text"
    private let kHS1ReebokActiveKey: String = "reebok_active"
    private let kHS1PlanDetailsKey: String = "plan_details"
    private let kHS1DurationKey: String = "duration"
    private let kHS1PriceKey: String = "price"
    
    // MARK: Properties
    public var packageId: Int?
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
        packageId = json[kHS1PackageIdKey].int
        internalIdentifier = json[kHS1InternalIdentifierKey].int
        text = json[kHS1TextKey].string
        reebokActive = json[kHS1ReebokActiveKey].boolValue
        if let items = json[kHS1PlanDetailsKey].array { self.planDetails = items.map { HSPlanDetails(json: $0) } }
        duration = json[kHS1DurationKey].string
        price = json[kHS1PriceKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = packageId { dictionary[kHS1PackageIdKey] = value }
        if let value = internalIdentifier { dictionary[kHS1InternalIdentifierKey] = value }
        if let value = text { dictionary[kHS1TextKey] = value }
        dictionary[kHS1ReebokActiveKey] = reebokActive
        if let value = planDetails { dictionary[kHS1PlanDetailsKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = duration { dictionary[kHS1DurationKey] = value }
        if let value = price { dictionary[kHS1PriceKey] = value }
        return dictionary
    }
    
}
