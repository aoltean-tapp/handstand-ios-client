//
//  HSError.swift
//  Handstand
//
//  Created by Fareeth John on 4/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

enum eErrorType: Int {
    case networkError = 999
    case internalServer = 1000
    case invalidAppVersion = 1001
    case updateAppVersion = 1002
    case emailPassword = 2000
    case noContent = 204
    case notAvailable = 503
    case invalidAccessToken = 403
    case invalidRequestWindow = 406
}

class HSError: NSObject {
    var message : String? = "Error"
    var code : eErrorType?
}
