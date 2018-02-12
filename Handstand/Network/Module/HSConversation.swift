//
//  HSConversation.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/12/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation

class HSConversation {
    var id: Int = 0
    var trainerId: Int = 0
    var trainerName: String = ""
    var trainerAvatar: String = ""
    var sessionStatus: String = ""
    var sessionDate: Date = Date()
    var lastContactDate: Date = Date()
    var lastMessage: String = ""
    var allMessages: [String] = []
}
