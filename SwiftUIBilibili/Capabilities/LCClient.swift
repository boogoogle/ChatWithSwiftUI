//
//  LCClient.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/18/20.
//  Copyright © 2020 boo. All rights reserved.
//

import Foundation
import UIKit
import LeanCloud

class LCClient {
    static var storedConversations: [IMConversation]?
    
    static var current: IMClient!
    
    static var currentConversation: IMConversation!
    
    static var eventObserverMap: [String: (IMClient, IMConversation, IMConversationEvent) -> Void] = [:]
    
    static let queue = DispatchQueue(label: "\(LCClient.self).queue")
    
    static func addEventObserver(key: String, closure: @escaping (IMClient, IMConversation, IMConversationEvent) -> Void) {
        self.queue.async {
            self.eventObserverMap[key] = closure
        }
    }
    
    static let delegator = LCClient()
}

extension LCClient: IMClientDelegate {
    func client(_ client: IMClient, event: IMClientEvent) {
        //
    }
    
    func client(_ client: IMClient, conversation: IMConversation, event: IMConversationEvent) {
        switch event {
            case .message(event: let messageEvent):
                switch messageEvent {
                    case .received(message: let message):
                        print(message)
                    default:
                        break
            }
            default:
                break
        }
    }
}
// 代理的方式不大好...
//protocol LCClieentDelegate: class {
//    func LCClientDidReceiveMessage(_ client: LCClient, receivedMessage: IMMessage)
//}
