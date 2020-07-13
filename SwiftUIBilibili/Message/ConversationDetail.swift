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
    private var conversation:  IMConversation!
    
    @EnvironmentObject private var conversationDetailData: ConversationDetailData
    @State var isInputerFocus = false
    @State var textMsg =  ""
    
    
    let uuid = UUID().uuidString
    init(conversation: IMConversation!) {
        self.conversation = conversation
    }
    
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
//        self.conversation.read(message: message)
        mainQueueExecuting {
            self.conversationDetailData.messages.append(message)
        }
        
    }
    func handleMessageUpdated(updatedMessage: IMMessage){
//        dPrint("------ message updated ----------111", updatedMessage)
    }
    
    func queryMessageHistory(isFirst: Bool, completion: @escaping((Result<Bool, Error>) -> Void) ){
        var start: IMConversation.MessageQueryEndpoint? = nil
        
        if let oldMessage = self.conversationDetailData.messages.first {
            start = IMConversation.MessageQueryEndpoint(
                messageID: oldMessage.ID,
                sentTimestamp: oldMessage.sentTimestamp,
                isClosed: true
            )
        }
        
        do {
            guard conversation != nil else {
                return
            }
            try conversation.queryMessage(
                start: start,
                policy: isFirst ? .onlyNetwork : .default
//                limit: 15
            ) { (result) in
                switch result {
                    case .success(value: let messageResults):
                        if isFirst {
                            self.conversation.read()
                        }
                        if !messageResults.isEmpty {
                            mainQueueExecuting {
                                let isOriginMessageEmpty = self.conversationDetailData.messages.isEmpty // scroll的时候判断是滚动到底部还是第一条消息
                                if
                                    let first = self.conversationDetailData.messages.first,
                                    let last = messageResults.last,
                                    let firstTimestamp = first.sentTimestamp,
                                    let lastTimestamp = last.sentTimestamp,
                                    firstTimestamp == lastTimestamp,
                                    let firstMessageID = first.ID,
                                    let lastMessageID = last.ID,
                                    firstMessageID == lastMessageID
                                {
                                    self.conversationDetailData.messages.removeFirst()
                                }
                                self.conversationDetailData.messages.insert(contentsOf: messageResults, at: 0)
                                
//                                self.tableView.reloadData()// 更新ui
//                                self.tableView.scrollToRow( // 滚动到底部
//                                    at: IndexPath(row: messageResults.count - 1, section: 0),
//                                    at: isOriginMessageEmpty ? .bottom : .top,
//                                    animated: false
//                                )
                            }
                        }
                        completion(.success(true))
                    case .failure(error: let error):
                        print(error)
                        completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
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
    func handleScroll(_ edge: Edge){
        print(edge, "edge")
    }
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all) // 没有这个,对于ZStack的onTapGesture不会生效
            if conversation != nil {
                VStack {
                    List(conversationDetailData.messages, id: \.ID){ (msg: IMMessage) in
                        VStack{
                            MessageWrapper(msg)
                        }
                    }
                    Spacer()
                    MessageInputer(conversation: conversation, textMessage: $textMsg, isFocus: $isInputerFocus)
                }
            }
        }.navigationBarTitle(conversation.name ?? "和神秘人的神秘对话")
        .onTapGesture {
            self.isInputerFocus = false
            self.hideKeyboard()
        }
        .offset(y: isInputerFocus ? -300 : 0)
        .onAppear{
            self.addObserverForClient()
            self.queryMessageHistory(isFirst:true){ _ in
                dPrint("消息加载完毕...☺")
            }
        }
    }
}
