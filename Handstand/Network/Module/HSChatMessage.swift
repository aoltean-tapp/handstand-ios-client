//
//  HSChatMessage.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/14/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation

struct HSChatAPIResult: Codable {
    var result: String = ""
    var messages: [HSChatMessage] = []
    
    enum CodingKeys: String, CodingKey {
        case result
        case messages
    }
}

class HSChatMessage: Codable {
    
    var id: Int = 0
    var chatId: Int = 0
    var userId: Int = 0
    var message: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case userId = "user_id"
        case message
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
