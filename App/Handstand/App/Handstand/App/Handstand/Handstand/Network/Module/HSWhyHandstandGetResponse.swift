//
//  HSWhyHandstandGetResponse.swift
//
//  Created by Ranjith Kumar on 12/27/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSWhyHandstandGetResponse:NSObject {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSWhyHandstandGetResponseResultKey: String = "result"
    private let kHSWhyHandstandGetResponseDataKey: String = "data"
    
    // MARK: Properties
    public var result: String?
    public var data: [HSWhyHandstandDataMeta] = Array<HSWhyHandstandDataMeta>()
    
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
        result = json[kHSWhyHandstandGetResponseResultKey].string
        if let items = json[kHSWhyHandstandGetResponseDataKey].array { data = items.map { HSWhyHandstandDataMeta(json: $0) } }
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = result { dictionary[kHSWhyHandstandGetResponseResultKey] = value }
        dictionary[kHSWhyHandstandGetResponseDataKey] = data.map { $0.dictionaryRepresentation() }
        return dictionary
    }
    
}
