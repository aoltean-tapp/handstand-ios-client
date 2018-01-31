//
//  HSPlanQuizDataCenter.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import Alamofire
import Stripe
import Crashlytics
import SwiftyJSON

class HSPlanQuizDataCenter: HSNetworkHandler {
    
    func getPlans(completion:@escaping (AsyncResult<HSGetPlanListResponse>)->()) {
        self.request("\(base_url)v3/planlists", method: .get, parameters: [:]).responseJSON { response in
            var error : HSError? = nil
            if let _JSON = response.result.value {
                let result = (_JSON as AnyObject).value(forKey: "result") as! String
                if result == "success" {
                    let json = JSON(_JSON)
                    let planResponse = HSGetPlanListResponse.init(json:json)
                    completion(AsyncResult.success(planResponse))
                }else if let errorObject: NSArray =  (_JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    completion(AsyncResult.failure(error))
                }
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completion(AsyncResult.failure(error))
            }
        }
    }
    
    func getQuizzes(completion:@escaping (AsyncResult<HSQuizGetResponse>)->()) {
        self.request("\(base_url)v3/quiz", method: .get, parameters: [:]).responseJSON { response in
            var error : HSError? = nil
            if let _JSON = response.result.value {
                let result = (_JSON as AnyObject).value(forKey: "result") as! String
                if result == "success" {
                    let json = JSON(_JSON)
                    let quizResponse = HSQuizGetResponse.init(json:json)
                    completion(AsyncResult.success(quizResponse))
                }else if let errorObject: NSArray =  (_JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    completion(AsyncResult.failure(error))
                }
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completion(AsyncResult.failure(error))
            }
        }
    }
    
    func postQuiz(with selectedQuiz : HSQuiz, completion:@escaping (AsyncResult<HSQuizPostResponse>)->()) {
        let parameters:[String:Int] = ["id" : selectedQuiz.internalIdentifier!]
        self.request("\(base_url)v3/quiz", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let _JSON = response.result.value {
                let result = (_JSON as AnyObject).value(forKey: "result") as! String
                if result == "success" {
                    let json = JSON(_JSON)
                    let quizPostResponse = HSQuizPostResponse.init(json:json)
                    completion(AsyncResult.success(quizPostResponse))
                }else if let errorObject: NSArray =  (_JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    completion(AsyncResult.failure(error))
                }
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completion(AsyncResult.failure(error))
            }
        }
    }
    
    func getWhyHandstandQueries(completion:@escaping (AsyncResult<HSWhyHandstandGetResponse>)->()) {
        self.request("\(base_url)v3/onboarding", method: .get, parameters: [:]).responseJSON { response in
            var error : HSError? = nil
            if let _JSON = response.result.value {
                let result = (_JSON as AnyObject).value(forKey: "result") as! String
                if result == "success" {
                    let json = JSON(_JSON)
                    let response = HSWhyHandstandGetResponse.init(json:json)
                    completion(AsyncResult.success(response))
                }else if let errorObject: NSArray =  (_JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    completion(AsyncResult.failure(error))
                }
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completion(AsyncResult.failure(error))
            }
        }
    }
    
    func postWhyHandstandQuery(with selectedQuery : HSWhyHandstandDataMeta, completion:@escaping (AsyncResult<Bool>)->()) {
        let parameters:[String:Int] = ["id" : selectedQuery.internalIdentifier!]
        self.request("\(base_url)v3/onboarding", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let _JSON = response.result.value {
                let result = (_JSON as AnyObject).value(forKey: "result") as! String
                if result == "success" {
                    completion(AsyncResult.success(true))
                }else if let errorObject: NSArray =  (_JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    completion(AsyncResult.failure(error))
                }
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completion(AsyncResult.failure(error))
            }
        }
    }
}
