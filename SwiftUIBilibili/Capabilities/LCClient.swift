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
//        本地消息通知怎么加呢? 还是说这里得用推送?
        switch event {
            case .unreadMessageCountUpdated:
                notify(text: "来自\(String(describing: conversation.name))的消息")
            default:
                break
        }
    }
}
// 代理的方式不大好...
//protocol LCClieentDelegate: class {
//    func LCClientDidReceiveMessage(_ client: LCClient, receivedMessage: IMMessage)
//}



// 本地消息通知
func notify(text: String){
    print("notify111",text)
    // 1
    let content = UNMutableNotificationContent()
    content.title = "新消息"
    content.body = text
    content.sound = UNNotificationSound.default
    
    //2
    //        let calendar = Calendar(identifier: .gregorian)
    //        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: Date())
    
    // 3
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2,repeats: false)
    // 4
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    // 5
    let center = UNUserNotificationCenter.current()
    center.add(request, withCompletionHandler: nil)
}
