//
//  HSGetPlanListResponse.swift
//
//  Created by Ranjith Kumar on 12/12/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class PlanListResponse:NSObject {
    public var planDetails: [HSPlanDetails]?
    public var isSelected:Bool = false
}

public class HSGetPlanListResponse {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSGetPlanListResponse2Key: String = "2"
    private let kHSGetPlanListResponse1Key: String = "1"
    private let kHSGetPlanListResponseResultKey: String = "result"
    private let kHSGetPlanListResponse0Key: String = "0"
    
    // MARK: Properties
    public var secondPlan: HSSecondPlanListResponse?
    public var firstPlan: HSFirstPlanListResponse?
    public var result: String?
    public var zerothPlan: HSZerothPlanListResponse?
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based xon the object
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
        secondPlan = HSSecondPlanListResponse(json: json[kHSGetPlanListResponse2Key])
        firstPlan = HSFirstPlanListResponse(json: json[kHSGetPlanListResponse1Key])
        result = json[kHSGetPlanListResponseResultKey].string
        zerothPlan = HSZerothPlanListResponse(json: json[kHSGetPlanListResponse0Key])
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = secondPlan { dictionary[kHSGetPlanListResponse2Key] = value.dictionaryRepresentation() }
        if let value = firstPlan { dictionary[kHSGetPlanListResponse1Key] = value.dictionaryRepresentation() }
        if let value = result { dictionary[kHSGetPlanListResponseResultKey] = value }
        if let value = zerothPlan { dictionary[kHSGetPlanListResponse0Key] = value.dictionaryRepresentation() }
        return dictionary
    }
    
    public func getPlanDetailsCount()->Int? {
        if let zerothPlanDetailsCount = self.firstPlan?.planDetails?.count,
            let firstPlanDetailsCount = self.firstPlan?.planDetails?.count,
            let secondPlanDetailsCount = self.secondPlan?.planDetails?.count {
            return zerothPlanDetailsCount + firstPlanDetailsCount + secondPlanDetailsCount
        } else {
            return 0
        }
    }
    
    public func getPlan(with section:Int)->PlanListResponse {
        let plans:[PlanListResponse] = [zerothPlan!,firstPlan!,secondPlan!]
        return plans[section]
    }
    
    public func getPlanDetails(with row:Int)->HSPlanDetails {
        var planDetails:[HSPlanDetails] = Array()
        for p in [zerothPlan!,firstPlan!,secondPlan!] as [PlanListResponse] {
            for d in p.planDetails! {
                planDetails.append(d)
            }
        }
        return planDetails[row]
    }
}
