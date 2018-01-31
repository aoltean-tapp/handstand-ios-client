//
//  HSGetNewSubscriptionsResponse.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/10/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: - HSGetNewSubscriptionsResponse
public class HSGetNewSubscriptionsResponse: NSObject {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSGetNewPackagesResponseResultKey: String = "result"
    private let kHSGetNewPackagesResponseDataKey: String = "data"
    
    // MARK: Properties
    public var result: String?
    public var data: HSGetNewPackagesData?
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        result = json[kHSGetNewPackagesResponseResultKey].string
        data = HSGetNewPackagesData(json: json[kHSGetNewPackagesResponseDataKey])
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = result { dictionary[kHSGetNewPackagesResponseResultKey] = value }
        if let value = data { dictionary[kHSGetNewPackagesResponseDataKey] = value.dictionaryRepresentation() }
        return dictionary
    }
}

//MARK: - HSNewSubscriptionPlans
public class HSNewSubscriptionPlans: NSObject {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSPlansText2Key: String = "text_2"
    private let kHSPlansSkuKey: String = "sku"
    private let kHSPlansInternalIdentifierKey: String = "id"
    private let kHSPlansDescriptionValueKey: String = "description"
    private let kHSPlansText1Key: String = "text_1"
    private let kHSPlansPriceKey: String = "price"
    private let kHSPlansDurationKey: String = "duration"
    
    // MARK: Properties
    public var text2: String?
    public var sku: String?
    public var internalIdentifier: Int?
    public var descriptionValue: [HSDescriptionValue]?
    public var text1: String?
    public var price: String?
    public var duration: String?
    public var isSelected:Bool = false
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        text2 = json[kHSPlansText2Key].string
        sku = json[kHSPlansSkuKey].string
        internalIdentifier = json[kHSPlansInternalIdentifierKey].int
        if let items = json[kHSPlansDescriptionValueKey].array { descriptionValue = items.map { HSDescriptionValue(json: $0) } }
        text1 = json[kHSPlansText1Key].string
        price = json[kHSPlansPriceKey].string
        duration = json[kHSPlansDurationKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = text2 { dictionary[kHSPlansText2Key] = value }
        if let value = sku { dictionary[kHSPlansSkuKey] = value }
        if let value = internalIdentifier { dictionary[kHSPlansInternalIdentifierKey] = value }
        if let value = descriptionValue { dictionary[kHSPlansDescriptionValueKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = text1 { dictionary[kHSPlansText1Key] = value }
        if let value = price { dictionary[kHSPlansPriceKey] = value }
        if let value = duration { dictionary[kHSPlansDurationKey] = value }
        return dictionary
    }
    
}

//MARK: - HSDescriptionValue
public class HSDescriptionValue: NSObject {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSDescriptionValueHeaderKey: String = "header"
    private let kHSDescriptionValueBodyKey: String = "body"
    
    // MARK: Properties
    public var header: String?
    public var body: String?
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        header = json[kHSDescriptionValueHeaderKey].string
        body = json[kHSDescriptionValueBodyKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = header { dictionary[kHSDescriptionValueHeaderKey] = value }
        if let value = body { dictionary[kHSDescriptionValueBodyKey] = value }
        return dictionary
    }
    
}

//MARK: - HSGetNewPackagesData
public class HSGetNewPackagesData:NSObject {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSDataPlansKey: String = "plans"
    
    // MARK: Properties
    public var plans: [HSNewSubscriptionPlans]?
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        if let items = json[kHSDataPlansKey].array { plans = items.map { HSNewSubscriptionPlans(json: $0) } }
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = plans { dictionary[kHSDataPlansKey] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
}


