//
//  HSChatNetworkHandler.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/13/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import Alamofire

class HSChatNetworkHandler: HSNetworkHandler {
    
    func getAllChats(completionHandler: @escaping (_ result: Result<[HSConversation]>) -> ()) {
        self.request("https://api-stage.handstandapp.com/api/v3/chat/get_all", method: .get, parameters: [:]).responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(HSConversation.dateFormatter)
                    
                    let apiResult: HSConversationsAPIResult = try! decoder.decode(HSConversationsAPIResult.self, from: responseData)
                    completionHandler(Result<[HSConversation]>.success(apiResult.chats))
                }
            case .failure(let error):
                completionHandler(Result<[HSConversation]>.failure(error))
            }
        }
    }
    
    func getChatMessages(for chatId: Int, completionHandler: @escaping (_ result: Result<[HSChatMessage]>) -> ()) {
        self.request("https://api-stage.handstandapp.com/api/v3/chat/messages/\(chatId)", method: .get, parameters: [:]).responseJSON { response in
            switch response.result {
            case .success:
                if let responseData = response.data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(HSChatMessage.dateFormatter)
                    
                    let apiResult: HSChatAPIResult = try! decoder.decode(HSChatAPIResult.self, from: responseData)
                    let sortedChatMessages = apiResult.messages.sorted() { $0.0.updatedAt < $0.1.updatedAt }
                    completionHandler(Result<[HSChatMessage]>.success(sortedChatMessages))
                }
            case .failure(let error):
                completionHandler(Result<[HSChatMessage]>.failure(error))
            }
        }
    }
}
