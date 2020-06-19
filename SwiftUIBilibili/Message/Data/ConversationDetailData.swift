//
//  ConversationDetailData.swift
//  Ipadyou
//
//  Created by Boo on 5/18/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import Combine
import LeanCloud

final class ConversationDetailData: ObservableObject {
    @Published var typingMessage: String = "说点什么吧"
    @Published var messages = [IMMessage]()
    
    func sendMsg(message: IMMessage) {
        do{
            try LCClient.currentConversation.send(message: message, completion: {[self] (result) in
                //                guard let self = self else {
                //                    return
                //                }
                switch result {
                    case .success:
                        self.messages.append(message)
                    case .failure(error: let error):
                        print(error)
                }
                
            })
            
        } catch {
            print(error)
        }
    }
}

