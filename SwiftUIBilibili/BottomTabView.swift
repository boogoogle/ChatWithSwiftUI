//
//  BottomTabView.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/2/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct BottomTabView: View {
    @EnvironmentObject var globalData: GlobalData
    func initIMClient(){
        do {
            let clientId: String = LCApplication.default.currentUser?.email!.rawValue as? String ?? ""
            if clientId != ""{
                print("initIMClient, 当前登录用户的Email是: ", clientId)
            }
            let client = try IMClient(
                ID: clientId,
                delegate: LCClient.delegator,
                eventQueue: LCClient.queue
            )
            self.open(client: client)
        } catch {
            print(error)
        }
    }
    func open(client: IMClient){
        client.open { (result) in
            switch result {
                case .success:
                    LCClient.current = client
                    self.addObserverForClient()
                    break
                case .failure(error: let error):
                    print(error)
            }
        }
    }
    func addObserverForClient() {
        let uuid = UUID().uuidString
        LCClient.addEventObserver(key: uuid) {(client, conversation, event) in
            switch event {
                case .left(byClientID: _, at: _):
                    self.handleConversationEventLeft(conversation: conversation, client: client)
                case .lastMessageUpdated(newMessage: let isNewMessage):
                    self.handleConversationEventLastMessageUpdated(conversation: conversation, isNewMessage: isNewMessage)
                case .unreadMessageCountUpdated:
                    self.handleConversationEventUnreadMessageCountUpdated(conversation: conversation)
                default:
                    break
            }
        }
    }
    func handleConversationEventLeft(conversation: IMConversation, client: IMClient) {
        
    }
    func handleConversationEventLastMessageUpdated(conversation: IMConversation, isNewMessage: Bool) {
//        print("lastmessageUpdated", isNewMessage)
        var isIn = false
        for(index,conv) in LCClient.currentConversationList.numbered() {
            if(conv.ID == conversation.ID) {
                LCClient.currentConversationList[index - 1] = conversation
                isIn = true
                break
            }
        }
        
        if !isIn {
            LCClient.currentConversationList.append(conversation)
        }
    }
    func handleConversationEventUnreadMessageCountUpdated(conversation: IMConversation) {
        self.globalData.unreadMessageCount = conversation.unreadMessageCount
        print(conversation.unreadMessageCount, "unread---")
        
    }
    var body: some View {
        
        TabView {
            Home().tabItem{
                Image(systemName: "person.3.fill")
                Text("广场")
            }
            
            MyConversations()
                .tabItem {
                    Image(systemName: "quote.bubble.fill")
                    Text("我的\(self.globalData.unreadMessageCount)")
            }
//                     
        }.onAppear{
            self.initIMClient()
        }
    }
}

