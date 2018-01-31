//
//  HSDeclineRequest.swift
//
//  Created by Ranjith Kumar on 11/3/17
//  Copyright (c) Handstand. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HSDeclineRequest {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kHSDeclineRequestScheduleTrainerKey: String = "schedule_trainer"
    private let kHSDeclineRequestFormattedLocationKey: String = "formatted_location"
    private let kHSDeclineRequestLastNameKey: String = "last_name"
    private let kHSDeclineRequestInternalIdentifierKey: String = "id"
    private let kHSDeclineRequestMobileKey: String = "mobile"
    private let kHSDeclineRequestSpecialityKey: String = "speciality"
    private let kHSDeclineRequestFirstNameKey: String = "first_name"
    private let kHSDeclineRequestAvatarKey: String = "avatar"
    private let kHSDeclineRequestSizeKey: String = "size"
    private let kHSDeclineRequestThumbnailKey: String = "thumbnail"
    private let kHSDeclineRequestStartsAtKey: String = "starts_at"
    private let kHSDeclineRequestOriginalTrainerDetailsKey: String = "original_trainer_details"
    private let kHSDeclineRequestZipcodeKey:String = "zip_code"
    
    // MARK: Properties
    public var scheduleTrainer: Bool = false
    public var formattedLocation: String?
    public var zipCode:String?
    public var lastName: String?
    public var internalIdentifier: Int?
    public var mobile: String?
    public var speciality: String?
    public var firstName: String?
    public var avatar: String?
    public var size: String?
    public var thumbnail: String?
    public var startsAt: String?
    public var originalTrainerDetails: HSOriginalTrainerDetails?
    var startDate : Date! = nil
    var startTime : String! = ""
    var weekDay: String! = ""
    var finalSessionTime:String = ""
    
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
        scheduleTrainer = json[kHSDeclineRequestScheduleTrainerKey].boolValue
        formattedLocation = json[kHSDeclineRequestFormattedLocationKey].string
        lastName = json[kHSDeclineRequestLastNameKey].string
        internalIdentifier = json[kHSDeclineRequestInternalIdentifierKey].int
        mobile = json[kHSDeclineRequestMobileKey].string
        speciality = json[kHSDeclineRequestSpecialityKey].string
        firstName = json[kHSDeclineRequestFirstNameKey].string
        avatar = json[kHSDeclineRequestAvatarKey].string
        size = json[kHSDeclineRequestSizeKey].string
        thumbnail = json[kHSDeclineRequestThumbnailKey].string
        startsAt = json[kHSDeclineRequestStartsAtKey].string
        originalTrainerDetails = HSOriginalTrainerDetails(json: json[kHSDeclineRequestOriginalTrainerDetailsKey])
        zipCode = json[kHSDeclineRequestZipcodeKey].string
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        startDate = dateFormate.date(from: startsAt!)
        dateFormate.dateFormat = "hh:mm a"
        startTime = dateFormate.string(from: startDate)
        dateFormate.dateFormat = "EEEE"
        weekDay = dateFormate.string(from: startDate)
        dateFormate.dateFormat = "MMMM dd"
        let date = dateFormate.string(from: startDate)
        finalSessionTime = weekDay + ", " + date + " " + "at" + " " + startTime
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[kHSDeclineRequestScheduleTrainerKey] = scheduleTrainer
        if let value = formattedLocation { dictionary[kHSDeclineRequestFormattedLocationKey] = value }
        if let value = lastName { dictionary[kHSDeclineRequestLastNameKey] = value }
        if let value = internalIdentifier { dictionary[kHSDeclineRequestInternalIdentifierKey] = value }
        if let value = mobile { dictionary[kHSDeclineRequestMobileKey] = value }
        if let value = speciality { dictionary[kHSDeclineRequestSpecialityKey] = value }
        if let value = firstName { dictionary[kHSDeclineRequestFirstNameKey] = value }
        if let value = avatar { dictionary[kHSDeclineRequestAvatarKey] = value }
        if let value = size { dictionary[kHSDeclineRequestSizeKey] = value }
        if let value = thumbnail { dictionary[kHSDeclineRequestThumbnailKey] = value }
        if let value = startsAt { dictionary[kHSDeclineRequestStartsAtKey] = value }
        if let value = originalTrainerDetails { dictionary[kHSDeclineRequestZipcodeKey] = value.dictionaryRepresentation() }
        if let value = zipCode {dictionary[kHSDeclineRequestZipcodeKey] = value}
        return dictionary
    }
}


