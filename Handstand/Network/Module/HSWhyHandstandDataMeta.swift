//
//  HSWhyHandstandDataMeta.swift
//
//  Created by Ranjith Kumar on 12/27/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSWhyHandstandDataMeta:NSObject {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSDataInternalIdentifierKey: String = "id"
    private let kHSDataTextKey: String = "text"
    
    // MARK: Properties
    public var internalIdentifier: Int?
    public var text: String?
    public var isSelected:Bool = false
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the classconvenience .
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
        internalIdentifier = json[kHSDataInternalIdentifierKey].int
        text = json[kHSDataTextKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = internalIdentifier { dictionary[kHSDataInternalIdentifierKey] = value }
        if let value = text { dictionary[kHSDataTextKey] = value }
        return dictionary
    }
    
}
