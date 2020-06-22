//
//  DanceGroundBottomCardView.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/21/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct DanceGroundBottomCardView: View {
    @State var friendEmail: String = "B@b.b"
    @State var showDetail: Bool = false
    //    @EnvironmentObject var conversationDetailData: ConversationDetailData
    @State var convsersationDetail = ConversationDetail()
    @State var unreadMessageCount = 0
    let uuid = UUID().uuidString
    
    func createNormalConversation(){
        print("createNormalConversation -- start")
        var memberSet = Set<String>()
        memberSet.insert(LCClient.current.ID)
        memberSet.insert(friendEmail)
        guard memberSet.count > 1 else {
            return
        }
        
        let name: String = {
            let sortedNames: [String] = memberSet.sorted()
            let name: String
            if sortedNames.count > 3 {
                name = [sortedNames[0], sortedNames[1], sortedNames[2], "..."].joined(separator: " & ")
            } else {
                name = sortedNames.joined(separator: " & ")
            }
            return name
        }()
        
        do {
            try LCClient.current.createConversation(clientIDs: memberSet, name: name, completion: {(result) in
                switch result {
                    case .success(value: let conversation):
                        LCClient.currentConversation = conversation
                        self.showDetail = true
                    case .failure(error: let error):
                        print(error)
                        break
                }
            })
        }catch {
            print("\(error)")
        }
    }
    
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
        print("open")
        client.open { (result) in
            print("IMClient open 结果",result)
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
        print("addstart")
        LCClient.addEventObserver(key: self.uuid) {(client, conversation, event) in
            
//            guard type(of: conversation) == IMConversation.self, let self = self else {
//                return
//            }
            print("addevent in DanceGroundBottomCardView")
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
        
    }
    func handleConversationEventUnreadMessageCountUpdated(conversation: IMConversation) {
        LCClient.currentConversation = conversation
        self.unreadMessageCount = conversation.unreadMessageCount
        print(conversation.unreadMessageCount, "unread---")
    }
    
    var body: some View {
        VStack(spacing: 20.0) {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
            
            VStack(alignment: .leading){
                Text("未读消息: \(self.unreadMessageCount)")
                if LCClient.currentConversation != nil && self.unreadMessageCount > 0 {
                    NormalConversationListCell(conversation: LCClient.currentConversation)
                        .onTapGesture {
                            self.showDetail = true
                    }
                }
            }
            
            Text("和朋友荡起双桨?")
            HStack {
                TextField("输入对方id畅所欲言", text: $friendEmail)
                Button(action:{
                    self.createNormalConversation()
                }){
                    Text("发起")
                }.sheet(isPresented: $showDetail){
                    self.convsersationDetail.environmentObject(ConversationDetailData())
                }
            }
            
            Spacer()
        }
            .frame(minWidth: 0, maxWidth: .infinity) // 使之宽度全屏
            .padding()
            .padding(.horizontal)
            .background(Color.white)// 这里不设置background,下面的shadow看不出来
            .cornerRadius(30)
            .shadow(radius: 20)
            .offset(y: 600)
            .onAppear(){
                self.initIMClient()
        }
    }
}
