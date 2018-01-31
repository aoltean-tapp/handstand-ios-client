//
//  HSNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 4/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import Alamofire

enum AsyncResult<T> {
    case success(T)
    case failure(HSError?)
}

class HSNetworkHandler: NSObject {
    
    class func headers()->[String:String] {
        if let t_accessToken = HSUserManager.shared.tempAccessToken {
            return ["Authorization" : "Bearer"+" "+t_accessToken,
                    "Timezone":TimeZone.current.identifier,
                    "user_agent":"IOS"]
        }
        if let accessToken = HSUserManager.shared.accessToken {
            return ["Authorization" : "Bearer"+" "+accessToken,
                    "Timezone":TimeZone.current.identifier,
                    "user_agent":"IOS"]
        }
        return [:]
    }
    
    public func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> HSDataRequest
    {
        let dataRequest = Alamofire.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: HSNetworkHandler.headers()
        )
        let hsDataRequest = HSDataRequest()
        hsDataRequest.dataRequest = dataRequest
        hsDataRequest.url = url
        hsDataRequest.method = method
        hsDataRequest.parameters = parameters
        hsDataRequest.encoding = encoding
        hsDataRequest.headers = headers
        return hsDataRequest
    }
    
    func processForError(_ response : DataResponse<Any>) -> HSError?  {
        let error : HSError? = HSError()
        if let JSON = response.result.value {
            if let errorObject: NSArray =  (JSON as AnyObject).value(forKey: "errors") as? NSArray{
                if let msg = errorObject.object(at: 0) as? String{
                    error?.message = msg
                }
                else if let msgs = errorObject.object(at: 0) as? NSDictionary{
                    debugPrint(msgs)
                    error?.message = msgs.value(forKey: "message") as? String
                }
                else{
                    error?.message = NSLocalizedString("internal_error", comment: "")
                }
                if let theCode = response.response?.statusCode{
                    error?.code = eErrorType(rawValue: theCode)
                }
                else{
                    error?.code = eErrorType.internalServer
                }
            }
            else{
                if let theCode = response.response?.statusCode{
                    error?.code = eErrorType(rawValue: theCode)
                }
                else{
                    error?.code = eErrorType.internalServer
                }
                error?.message = NSLocalizedString("internal_error", comment: "")
            }
        }
        else{
            error?.code = eErrorType.networkError
            error?.message = NSLocalizedString("network_error", comment: "")
        }
        return error
    }
    
}

class HSDataRequest : NSObject {
    
    var dataRequest : DataRequest! = nil
    var url : URLConvertible! = nil
    var method : HTTPMethod = .get
    var parameters : Parameters? = nil
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders? = nil

    public func responseJSON(
        completionHandler: @escaping (DataResponse<Any>) -> Void)
    {
        dataRequest.responseJSON { (response) in
            if let theCode = response.response?.statusCode{
                if theCode == eErrorType.invalidAccessToken.rawValue { //Token expired
//                    if let userEmail = PDKeychainBindings.shared().string(forKey: kUserEmail) {
//                        let userPassword = PDKeychainBindings.shared().string(forKey: kUserPassword)
                    let userEmail = HSUserManager.shared.email
                    let userPassword = HSUserManager.shared.password
            HSUserNetworkHandler().login(userEmail!, password: userPassword!, completionHandler: { (success, error) in
                            if success {
//                                self.parameters?.updateValue("\((HSUserManager.shared.currentUser?.accessToken)!)", forKey: kUserAccessToken)
                                self.dataRequest = HSNetworkHandler().request(self.url, method: self.method, parameters: self.parameters , encoding: self.encoding, headers: self.headers).dataRequest
                                self.dataRequest.responseJSON(completionHandler: completionHandler)
                            }
                            else {
                                completionHandler(response)
                            }
                        })
                    }
                    else{
                    completionHandler(response)
//                        HSController.defaultController.getMainController().doLogout()
                    }
                }
                else{
                    completionHandler(response)
                }
            }
//            else{
//                completionHandler(response)
//            }
    }
}
