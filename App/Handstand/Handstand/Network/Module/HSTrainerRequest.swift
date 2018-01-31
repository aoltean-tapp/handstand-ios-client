//
//  TrainerRequest.swift
//
//  Created by Ranjith Kumar on 10/08/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class HSTrainerRequest: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let formattedLocation = "formatted_location"
        static let lastName = "last_name"
        static let status = "status"
        static let id = "id"
        static let mobile = "mobile"
        static let speciality = "speciality"
        static let firstName = "first_name"
        static let avatar = "avatar"
        static let size = "size"
        static let trainerId = "trainer_id"
        static let thumbnail = "thumbnail"
        static let startsAt = "starts_at"
        static let color = "color"
    }
    
    // MARK: Properties
    public var formattedLocation: String?
    public var lastName: String?
    public var status: Int?
    public var id: Int?
    public var mobile: String?
    public var speciality: String?
    public var firstName: String?
    public var avatar: String?
    public var size: String?
    public var trainerId: Int?
    public var thumbnail: String?
    public var startsAt: String?
    public var startDate : Date! = nil
    public var startTime : String! = ""
    public var color: String! = ""
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        formattedLocation = json[SerializationKeys.formattedLocation].string
        lastName = json[SerializationKeys.lastName].string
        status = json[SerializationKeys.status].int
        id = json[SerializationKeys.id].int
        mobile = json[SerializationKeys.mobile].string
        speciality = json[SerializationKeys.speciality].string
        firstName = json[SerializationKeys.firstName].string
        avatar = json[SerializationKeys.avatar].string
        size = json[SerializationKeys.size].string
        trainerId = json[SerializationKeys.trainerId].int
        thumbnail = json[SerializationKeys.thumbnail].string
        startsAt = json[SerializationKeys.startsAt].string
        color = json[SerializationKeys.color].string
        if let at = startsAt {
            if at.characters.count > 0 {
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                startDate = dateFormate.date(from: startsAt!)
                dateFormate.dateFormat = "hh:mm a"
                startTime = dateFormate.string(from: startDate)
            }
        }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = formattedLocation { dictionary[SerializationKeys.formattedLocation] = value }
        if let value = lastName { dictionary[SerializationKeys.lastName] = value }
        if let value = status { dictionary[SerializationKeys.status] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = mobile { dictionary[SerializationKeys.mobile] = value }
        if let value = speciality { dictionary[SerializationKeys.speciality] = value }
        if let value = firstName { dictionary[SerializationKeys.firstName] = value }
        if let value = avatar { dictionary[SerializationKeys.avatar] = value }
        if let value = size { dictionary[SerializationKeys.size] = value }
        if let value = trainerId { dictionary[SerializationKeys.trainerId] = value }
        if let value = thumbnail { dictionary[SerializationKeys.thumbnail] = value }
        if let value = startsAt { dictionary[SerializationKeys.startsAt] = value }
        if let value = color {dictionary[SerializationKeys.color] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.formattedLocation = aDecoder.decodeObject(forKey: SerializationKeys.formattedLocation) as? String
        self.lastName = aDecoder.decodeObject(forKey: SerializationKeys.lastName) as? String
        self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? Int
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.mobile = aDecoder.decodeObject(forKey: SerializationKeys.mobile) as? String
        self.speciality = aDecoder.decodeObject(forKey: SerializationKeys.speciality) as? String
        self.firstName = aDecoder.decodeObject(forKey: SerializationKeys.firstName) as? String
        self.avatar = aDecoder.decodeObject(forKey: SerializationKeys.avatar) as? String
        self.size = aDecoder.decodeObject(forKey: SerializationKeys.size) as? String
        self.trainerId = aDecoder.decodeObject(forKey: SerializationKeys.trainerId) as? Int
        self.thumbnail = aDecoder.decodeObject(forKey: SerializationKeys.thumbnail) as? String
        self.startsAt = aDecoder.decodeObject(forKey: SerializationKeys.startsAt) as? String
        self.color = aDecoder.decodeObject(forKey: SerializationKeys.color) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(formattedLocation, forKey: SerializationKeys.formattedLocation)
        aCoder.encode(lastName, forKey: SerializationKeys.lastName)
        aCoder.encode(status, forKey: SerializationKeys.status)
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(mobile, forKey: SerializationKeys.mobile)
        aCoder.encode(speciality, forKey: SerializationKeys.speciality)
        aCoder.encode(firstName, forKey: SerializationKeys.firstName)
        aCoder.encode(avatar, forKey: SerializationKeys.avatar)
        aCoder.encode(size, forKey: SerializationKeys.size)
        aCoder.encode(trainerId, forKey: SerializationKeys.trainerId)
        aCoder.encode(thumbnail, forKey: SerializationKeys.thumbnail)
        aCoder.encode(startsAt, forKey: SerializationKeys.startsAt)
        aCoder.encode(startsAt, forKey: SerializationKeys.color)
    }
    
    func partialTrainerName() -> String {
        var partialName = self.firstName
        if let lName = self.lastName {
            if lName.characters.count > 0 {
                partialName = partialName! + " " + "\(lName.characters.first!)."
            }
        }
        return partialName!
    }
    
}
