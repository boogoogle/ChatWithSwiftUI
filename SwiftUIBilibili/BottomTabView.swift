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
            
            
            try client.prepareLocalStorage { (result) in
                switch result {
                    case .success:
                        do {
                            try client.getAndLoadStoredConversations(completion: { result in
                                switch result {
                                    case .success(value: let storedConversations):
                                        var conversations: [IMConversation] = []
                                        var serviceConversations: [IMServiceConversation] = []
                                        for item in storedConversations {
                                            if type(of: item) == IMConversation.self {
                                                conversations.append(item)
                                            } else if let serviceItem = item as? IMServiceConversation {
                                                serviceConversations.append(serviceItem)
                                            }
                                        }
                                        self.open(
                                            client: client,
//                                                isReopen: isReopen,
                                            storedConversations: (conversations.isEmpty ? nil : conversations),
                                            storedServiceConversations: (serviceConversations.isEmpty ? nil : serviceConversations)
                                        )
                                        break
                                    case .failure(error: let error):
                                        dPrint(error)
                                    }
                            })
                        } catch {
                            dPrint(error)
                    }
                    case .failure(error: let error):
                        dPrint(error)
                    }
            }
        } catch {
            print(error)
        }
    }
    func open(
        client: IMClient,
        isReopen: Bool? = false,
        storedConversations: [IMConversation]? = nil,
        storedServiceConversations: [IMServiceConversation]? = nil // 这个是啥???订阅号之类的?
    ){
        client.open(options: .default){ (result) in
            switch result {
                case .success:
                    mainQueueExecuting {
                        LCClient.current = client
                        self.globalData.currentConversationList = storedConversations ?? []
//                        LCClient.storedConversations = storedConversations
//                        LCClient.storedServiceConversations = storedServiceConversations
                        self.addObserverForClient()
                    }
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
        for(index,conv) in self.globalData.currentConversationList.numbered() {
            if(conv.ID == conversation.ID) {
                mainQueueExecuting {
                    self.globalData.currentConversationList[index-1] = conversation
//                    self.globalData.currentConversationList.append(conversation)
                }
                
                isIn = true
                break
            }
        }
        
        if !isIn {
            mainQueueExecuting{
                self.globalData.currentConversationList.append(conversation)
            }
        }
    }
    func handleConversationEventUnreadMessageCountUpdated(conversation: IMConversation) {
        mainQueueExecuting {
            self.globalData.unreadMessageCount = conversation.unreadMessageCount
        }
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
        }
        .onAppear{
            self.initIMClient()
        }
    }
}

