//
//  HSGetVersionResponse.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/10/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: - HSGetVersionResponse
public struct HSGetVersionResponse {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSGetVersionResponseResultKey: String = "result"
    private let kHSGetVersionResponseDataKey: String = "data"
    
    // MARK: Properties
    public var result: String?
    public var data: HSGetVersionData?
    
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
        result = json[kHSGetVersionResponseResultKey].string
        data = HSGetVersionData(json: json[kHSGetVersionResponseDataKey])
    }
}

//MARK: - HSGetVersionData
public struct HSGetVersionData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSDataVersionKey: String = "version"
    private let kHSDataAdvanceHourKey: String = "advanceHour"
    
    // MARK: Properties
    public var version: HSVersion?
    public var advanceHour: Int?
    
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
        version = HSVersion(json: json[kHSDataVersionKey])
        advanceHour = json[kHSDataAdvanceHourKey].int
    }
  
}

//MARK: - HSVersion
public struct HSVersion {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSiOSVersionKey: String = "ios"
    
    // MARK: Properties
    public var iOS: HSIos?
    
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
        iOS = HSIos.init(json: json[kHSiOSVersionKey])
    }
    
}

public struct HSIos {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSIosClientKey: String = "client"
    
    // MARK: Properties
    public var client: HSClientVersion?
    
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
        client = HSClientVersion(json: json[kHSIosClientKey])
    }
}


//MARK: - HSClientVersion
public class HSClientVersion {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSClientRequiredVersionKey: String = "requiredVersion"
    private let kHSClientMinimumVersionKey: String = "minimumVersion"
    
    // MARK: Properties
    public var requiredVersion: String?
    public var minimumVersion: String?
    
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
        requiredVersion = json[kHSClientRequiredVersionKey].string
        minimumVersion = json[kHSClientMinimumVersionKey].string
    }
}
