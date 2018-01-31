//
//  HSVideo.swift
//  Handstand
//
//  Created by Fareeth John on 4/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import Alamofire

class Video: NSObject {
    var url : String?
    var resolution : String?
    var fps : String?
    var format : String?
}

enum eVideoType: Int {
    case daily = 1
    case weekly = 2
}

enum eVideoResolution: String {
    case low = "360p"
    case medium = "480p"
    case high = "1080p"
}


class HSVideo: NSObject {
    
    var title : String?
    var classType : String?
    var id : String?
    var duration : String?
    var thumbnail : String?
    var audio_file : String?
    var video : Array<Video>! = []
    var type : eVideoType = .daily
    var bulletPoints : Array<String>? = []
    
    init(withData data : NSDictionary) {
        super.init()
        title = data.value(forKey: "title") as? String
        classType = data.value(forKey: "sub_title") as? String
        duration = data.value(forKey: "duration") as? String
        if let points = data.value(forKey: "bullet_points") as? NSArray {
            bulletPoints = points as? Array<String>
        }
        if let audioFile = data.value(forKey: "audio_file") as? String {
            audio_file = audioFile
        }
        updateVideoDuration()
        if let theImgURL = data.value(forKey: "thumb_nail") as? String {
            thumbnail = theImgURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        }
        id = "\(data.value(forKey: "id"))"
        
        let theVideoData = data.value(forKey: "video") as! Array<NSDictionary>
        for theVideo in theVideoData {
            let videoObject = Video()
            for (key, value) in theVideo {
                let keyName = key as! String
                let keyValue: AnyObject = value as AnyObject
                // If property exists
                if  videoObject.responds(to: NSSelectorFromString(keyName)) {
                    if (keyValue is NSNull) == false{
                        videoObject.setValue("\(keyValue)", forKey: keyName)
                    }
                }
            }
            video.append(videoObject)
        }
    }
    
    func typeTitle() -> String {
        var theTypeStr = ""
        switch type {
        case .daily:
            theTypeStr = "Daily Video"
            break
        case .weekly:
            theTypeStr = "Weekly Video"
            break
        }
        return theTypeStr
    }
    
    private func getVideoURLForResolution(_ resolution : eVideoResolution) -> URL {
        let res = video.filter(
            {
                (e) -> Bool in
                if e.resolution == resolution.rawValue {
                    return true
                } else {
                    return false
                }
        })
        return URL(string: res[0].url!)!
    }
    
    
    func optimiziedVideo() -> URL {
        let net = NetworkReachabilityManager()
        var videoURL = getVideoURLForResolution(.medium)
        if (net?.isReachableOnEthernetOrWiFi)! {
            if Display.typeIsLike != .iphone4 && Display.typeIsLike != .iphone5 {
                videoURL = getVideoURLForResolution(.high)
            }
        }
        return videoURL
    }
    
    func updateVideoDuration()  {
        let theDuration = duration
        let durationArr = theDuration?.components(separatedBy: ":")
        if (durationArr?.count)! > 2 {
            let firstValue = durationArr?[0]
            if Int(firstValue!)! == 0 {
                duration = String(Int((durationArr?[1])!)!) + ":" + (durationArr?[2])!
            }
        }
    }
    
}
