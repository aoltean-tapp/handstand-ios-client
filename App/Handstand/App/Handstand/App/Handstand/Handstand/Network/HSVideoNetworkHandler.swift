//
//  HSVideoNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 4/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSVideoNetworkHandler: HSNetworkHandler {
    func getDailyVideo(_ completionHandler: @escaping (HSVideoSession?, HSError?) -> ()) -> () {
        self.request("\(url)workoutvideo", method: .get, headers : HSNetworkHandler.headers() ).responseJSON { response in
            var error : HSError? = nil
            var theVideo : HSVideoSession? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        theVideo = HSVideoSession(withData: JSON as! NSDictionary)
                        HSAppManager.shared.videoSession = theVideo
                        completionHandler(theVideo, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(theVideo, error)
        }
    }
}
