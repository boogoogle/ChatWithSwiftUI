//
//  ConversationDetail.swift
//  Ipadyou
//
//  Created by boo on 5/14/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct ConversationDetail: View {
    
    @EnvironmentObject private var conversationDetainData: ConversationDetailData
    @State var isInputerFocus = false
    @State var textMsg =  "Say something"
    @State var conversation:  IMConversation! = LCClient.currentConversation
    
    let uuid = UUID().uuidString
    
    func addObserverForClient() {
        LCClient.addEventObserver(key: self.uuid, closure: {[self] (client, conversation, event) in
//            guard let self = self, self.conversation.ID == conversation.ID else {
//                return
//            }
            switch event {
                case .message(event: let messageEvent):
                    switch messageEvent {
                        case let .received(message: message):
                            self.handleMessageReceived(message: message)
                        case let .updated(updatedMessage: updatedMessage, reason: _):
                            self.handleMessageUpdated(updatedMessage: updatedMessage)
                        default:
                            break
                }
                default:
                    break
            }
            
            
        })
    }
    
    func handleMessageReceived(message: IMMessage){
        print("------ message received ----------111", message)
        self.conversationDetainData.messages.append(message)
    }
    func handleMessageUpdated(updatedMessage: IMMessage){
        print("------ message updated ----------111", updatedMessage)
    }
    
    func queryMessageHistory(){
        do {
            try conversation.queryMessage(limit: 10) { (result) in
                switch result {
                    case .success(value: let messages):
                        self.conversationDetainData.messages = messages
                        print(messages)
                    case .failure(error: let error):
                        print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func hideKeyboard(){
        /**
         通过将target设置为nil，让系统自动遍历响应链
         从而响应链当前第一响应者响应我们自定义的方法"
         */
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all) // 没有这个,对于ZStack的onTapGesture不会生效
            if conversation != nil {
                VStack {
                    Text(conversation.name ?? "_")
                    Text("未读消息: \(self.conversation.unreadMessageCount)")
                    List(self.conversationDetainData.messages,id: \.ID){ (msg: IMMessage) in
                        VStack{
                            TextMessageCell(message: msg as! IMTextMessage)
                        }
                    }
                    Spacer()
                    MessageInputer(textMessage: $textMsg, isFocus: $isInputerFocus).environmentObject(self.conversationDetainData)
                }
            }
        }.onTapGesture {
            self.isInputerFocus = false
            self.hideKeyboard()
        }
        .offset(y: isInputerFocus ? -300 : 0)
        .onAppear{
            self.conversation = LCClient.currentConversation
            self.addObserverForClient()
            self.queryMessageHistory()
        }
    }
}

//struct ConversationDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationDetail()
//        .environmentObject(ConversationDetailData())
//    }
//}
