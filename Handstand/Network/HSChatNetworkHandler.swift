//
//  HSChatNetworkHandler.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/13/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import Alamofire

struct HSChatAPIResult: Codable {
    var result: String = ""
    var chats: [HSConversation] = []
    
    enum CodingKeys: String, CodingKey {
        case result
        case chats
    }
}

class HSChatNetworkHandler: HSNetworkHandler {
    
    func getAllChats(completionHandler: @escaping (_ result: Result<[HSConversation]>) -> ()) {
        self.request("https://api-stage.handstandapp.com/api/v3/chat/get_all", method: .get, parameters: [:]).responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(HSConversation.dateFormatter)
                    
                    let apiResult = try! decoder.decode(HSChatAPIResult.self, from: responseData)
                    completionHandler(Result<[HSConversation]>.success(apiResult.chats))
                }
            case .failure(let error):
                completionHandler(Result<[HSConversation]>.failure(error))
            }
//            error = HSError()
//            error?.code = eErrorType.internalServer
//            error?.message = NSLocalizedString("internal_error", comment: "")
//            completionHandler(false, error)
        }
    }
}
