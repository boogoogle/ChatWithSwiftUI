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
    @State var currentTab = "my"  // my
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
                        LCClient.currentIMClient = client
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
        var isIn = false
        for(index,conv) in self.globalData.currentConversationList.numbered() {
            if(conv.ID == conversation.ID) {
                mainQueueExecuting {
                    self.globalData.currentConversationList[index-1] = conversation
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
    }
    var body: some View {
        ZStack {
            VStack {
                if currentTab == "home" {
                    Home()
                } else if currentTab == "diu"{
                    ArbitraryMessageView()
                } else {
                    MyConversations()
                }
                if self.globalData.isShowBottomTab {
                    GeometryReader { geometry in
                        HStack(alignment:.bottom){
                            Group {
                                
                                VStack{
                                    Image(systemName: "person.3.fill")
                                    Text("广场")
                                }
                                .frame(width: geometry.size.width / 3)
                                .foregroundColor(self.currentTab == "home" ? .blue : .gray)
                                .onTapGesture {
                                    self.currentTab = "home"
                                }
                                
                                VStack{
                                    Image(systemName: "plus.circle.fill")
                                    Text("发丢")
                                }
                                .frame(width: geometry.size.width / 3)
                                .foregroundColor(self.currentTab == "diu" ? .blue : .gray)
                                .onTapGesture {
                                    self.currentTab = "diu"
                                }
                                
                                VStack(){
                                    Image(systemName: "quote.bubble.fill")
                                    if self.globalData.unreadMessageCount > 0 {
                                            Text("\(self.globalData.unreadMessageCount)").foregroundColor(.red)
                                    } else {
                                        Text("我的")
                                    }
                                }
                                .frame(width: geometry.size.width / 3)
                                .foregroundColor(self.currentTab == "my" ? .blue : .gray)
                                .onTapGesture {
                                    self.currentTab = "my"
                                }
                                
                            }
                            
                        }
                        .font(.system(size: 14.0))
                    }.frame(height: 60)
                }
            }.onAppear{
                self.initIMClient()
            }
//            if globalData.showLogin {
                ZStack{
                        LoginView()
                        VStack {
                            HStack {
                                Spacer()
                                CircleButton(icon: "xmark")
                                    .onTapGesture {
                                        self.globalData.showLogin = false
                                }
                            }
                            Spacer()
                        }.padding()
                }
                .offset(y: self.globalData.showLogin ? 0 : MAINHEIGHT)
                .animation(.easeInOut)
//            }
        }
    }
}

