//
//  HSConversation.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/12/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation

//class HSConversation {
//    var id: Int = 0
//    var trainerId: Int = 0
//    var trainerName: String = ""
//    var trainerAvatar: String = ""
//    var sessionStatus: String = ""
//    var sessionDate: Date = Date()
//    var lastContactDate: Date = Date()
//    var lastMessage: String = ""
//    var allMessages: [String] = []
//}

class HSConversation: Codable {
    var id: Int = 0
    var name: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter
    }
}
