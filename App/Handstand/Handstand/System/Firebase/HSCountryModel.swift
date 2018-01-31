//
//  HSCountryModel.swift
//
//  Created by Ranjith Kumar on 8/31/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSCountryModel {
   fileprivate let base: UInt32 = 127397
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSCountryModelNameKey: String = "name"
    private let kHSCountryModelE164CcKey: String = "e164_cc"
    private let kHSCountryModelGeographicKey: String = "geographic"
    private let kHSCountryModelDisplayNameKey: String = "display_name"
    private let kHSCountryModelE164ScKey: String = "e164_sc"
    private let kHSCountryModelIso2CcKey: String = "iso2_cc"
    private let kHSCountryModelE164KeyKey: String = "e164_key"
    private let kHSCountryModelLevelKey: String = "level"
    private let kHSCountryModelExampleKey: String = "example"
    private let kHSCountryModelDisplayNameNoE164CcKey: String = "display_name_no_e164_cc"
    private let kHSCountryModelFullExampleWithPlusSignKey: String = "full_example_with_plus_sign"
    
    // MARK: Properties
    public var name: String?
    public var e164Cc: String?
    public var geographic: Bool = false
    public var displayName: String?
    public var e164Sc: Int?
    public var flag: String?
    public var iso2Cc: String?
    public var e164Key: String?
    public var level: Int?
    public var example: String?
    public var displayNameNoE164Cc: String?
    public var fullExampleWithPlusSign: String?
    
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
        name = json[kHSCountryModelNameKey].string
        e164Cc = json[kHSCountryModelE164CcKey].string
        geographic = json[kHSCountryModelGeographicKey].boolValue
        displayName = json[kHSCountryModelDisplayNameKey].string
        e164Sc = json[kHSCountryModelE164ScKey].int
        iso2Cc = json[kHSCountryModelIso2CcKey].string
        flag = iso2Cc?.unicodeScalars.flatMap { String.init(UnicodeScalar(base + $0.value)!) }.joined()
        e164Key = json[kHSCountryModelE164KeyKey].string
        level = json[kHSCountryModelLevelKey].int
        example = json[kHSCountryModelExampleKey].string
        displayNameNoE164Cc = json[kHSCountryModelDisplayNameNoE164CcKey].string
        fullExampleWithPlusSign = json[kHSCountryModelFullExampleWithPlusSignKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name { dictionary[kHSCountryModelNameKey] = value }
        if let value = e164Cc { dictionary[kHSCountryModelE164CcKey] = value }
        dictionary[kHSCountryModelGeographicKey] = geographic
        if let value = displayName { dictionary[kHSCountryModelDisplayNameKey] = value }
        if let value = e164Sc { dictionary[kHSCountryModelE164ScKey] = value }
        if let value = iso2Cc { dictionary[kHSCountryModelIso2CcKey] = value }
        if let value = e164Key { dictionary[kHSCountryModelE164KeyKey] = value }
        if let value = level { dictionary[kHSCountryModelLevelKey] = value }
        if let value = example { dictionary[kHSCountryModelExampleKey] = value }
        if let value = displayNameNoE164Cc { dictionary[kHSCountryModelDisplayNameNoE164CcKey] = value }
        if let value = fullExampleWithPlusSign { dictionary[kHSCountryModelFullExampleWithPlusSignKey] = value }
        return dictionary
    }
    
}
