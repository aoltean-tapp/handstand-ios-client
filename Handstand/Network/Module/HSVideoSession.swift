//
//  HSVideoSession.swift
//  Handstand
//
//  Created by Fareeth John on 4/10/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSVideoSession: NSObject {
    var dailyVideo : HSVideo! = nil
    var weeklyVideo : HSVideo! = nil

    init(withData data : NSDictionary) {
        super.init()
        dailyVideo = HSVideo(withData: data)
        dailyVideo.type = .daily
//        if let dailyVideoData = data.value(forKey: "daily") as? NSDictionary {
//            dailyVideo = HSVideo(withData: dailyVideoData)
//            dailyVideo.type = .daily
//        }
//        if  let weeklyVideoData = data.value(forKey: "weekly") as? NSDictionary {
//            weeklyVideo = HSVideo(withData: weeklyVideoData)
//            weeklyVideo.type = .weekly
//        }
    }
}
