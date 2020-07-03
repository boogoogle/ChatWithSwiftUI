//
//  CreateConversation.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/21/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct CreateConversation: View {
    @State var friendEmail: String = ""
    @State var showDetail: Bool = false
    @State var convsersationDetail = ConversationDetail()
    @EnvironmentObject var globalData: GlobalData
    
    let uuid = UUID().uuidString
    let screenHeight = UIScreen.main.bounds.height
    
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
                        print("showDetail", self.showDetail)
                        self.addObserverForClient()
                    case .failure(error: let error):
                        print(error)
                        break
                }
            })
        }catch {
            print("\(error)")
        }
    }
    
    func addObserverForClient() {
        LCClient.addEventObserver(key: self.uuid) {(client, conversation, event) in
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
        self.globalData.unreadMessageCount = conversation.unreadMessageCount
        print(conversation.unreadMessageCount, "unread---")
    }
    
    var body: some View {
        
            VStack(spacing: 20.0) {
//                Rectangle()
//                    .frame(width: 60, height: 6)
//                    .cornerRadius(3.0)
//                    .opacity(0.1)
                
                VStack(alignment: .leading){
                    Text("未读消息: \(self.globalData.unreadMessageCount)")
                    if LCClient.currentConversation != nil && self.globalData.unreadMessageCount > 0 {
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
                        Text("发起").foregroundColor(.blue)
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
    }
}
