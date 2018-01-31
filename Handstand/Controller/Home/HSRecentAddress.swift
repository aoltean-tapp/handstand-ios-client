//
//  HSRecentAddress.swift
//
//  Created by Ranjith Kumar on 11/28/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSRecentAddress {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSRecentAddressFormattedAddressKey: String = "formatted_address"
    private let kHSRecentAddressLocationKey: String = "location"
    private let kHSRecentAddressZipCodeKey: String = "zip_code"
    private let kHSRecentAddressPlaceIdKey: String = "placeid"
    
    // MARK: Properties
    public var formattedAddress: String?
    public var location: HSLocation?
    public var zipCode: String?
    public var placeId : String?
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public init(object: Dictionary<String,Any>) {
        formattedAddress = object[kHSRecentAddressFormattedAddressKey] as? String
        location = HSLocation.init(object: object[kHSRecentAddressLocationKey] as! Dictionary<String, Any>)
        zipCode = object[kHSRecentAddressZipCodeKey] as? String
        placeId = object[kHSRecentAddressPlaceIdKey] as? String

//        location = HSLocation.init(object: json[kHSRecentAddressLocationKey].dictionaryObject as Any)
//        zipCode = json[kHSRecentAddressZipCodeKey].string
//        placeId = json[kHSRecentAddressPlaceIdKey].string
//        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
//    public init(json: JSON) {
//        formattedAddress = json["formatted_address"].string
//        location = HSLocation.init(object: json[kHSRecentAddressLocationKey].dictionaryObject as Any)
//        zipCode = json[kHSRecentAddressZipCodeKey].string
//        placeId = json[kHSRecentAddressPlaceIdKey].string
//    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = formattedAddress { dictionary[kHSRecentAddressFormattedAddressKey] = value }
        if let value = location { dictionary[kHSRecentAddressLocationKey] = value.dictionaryRepresentation() }
        if let value = zipCode { dictionary[kHSRecentAddressZipCodeKey] = value }
        if let value = placeId {dictionary[kHSRecentAddressPlaceIdKey] = value } 
        return dictionary
    }
    
}
