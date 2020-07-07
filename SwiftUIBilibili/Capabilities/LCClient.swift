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
        // 单个Conversation的订阅, 主要用在聊天详情页面
        for item in LCClient.eventObserverMap.values {
            item(client, conversation, event)
        }
    }
}
// 代理的方式不大好...
//protocol LCClieentDelegate: class {
//    func LCClientDidReceiveMessage(_ client: LCClient, receivedMessage: IMMessage)
//}
