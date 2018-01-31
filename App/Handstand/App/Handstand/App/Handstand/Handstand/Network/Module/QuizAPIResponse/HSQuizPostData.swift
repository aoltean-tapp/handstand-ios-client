//
//  HSQuizPostData.swift
//
//  Created by Ranjith Kumar on 12/12/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct HSQuizPostData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSDataColorAttributeKey: String = "colorMeta"
    private let kHSDataBodyKey: String = "body"
    private let kHSQuizPostResponseDataHeaderKey: String = "header"
    private let kHSQuizPostResponseDataFooterKey: String = "footer"
    
    // MARK: Properties
    public var colorAttribute: HSColorAttribute?
    public var body: String?
    public var header: String?
    public var footer:String?
    
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
        colorAttribute = HSColorAttribute(json: json[kHSDataColorAttributeKey])
        body = json[kHSDataBodyKey].string
        header = json[kHSQuizPostResponseDataHeaderKey].string
        footer = json[kHSQuizPostResponseDataFooterKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = colorAttribute { dictionary[kHSDataColorAttributeKey] = value.dictionaryRepresentation() }
        if let value = body { dictionary[kHSDataBodyKey] = value }
        if let value = header { dictionary[kHSQuizPostResponseDataHeaderKey] = value }
        if let value = footer { dictionary[kHSQuizPostResponseDataFooterKey] = value }
        return dictionary
    }
    
}
