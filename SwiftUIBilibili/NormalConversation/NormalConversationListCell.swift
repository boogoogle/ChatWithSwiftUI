//
//  NormalConversationListCell.swift
//  Ipadyou
//
//  Created by boo on 5/8/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct NormalConversationListCell: View {
    var conversation: IMConversation!
    
    @State var convLastMessageContentText: String = ""
    @State var convName = ""
    @State var members = ""
    @State var time = ""
    
    func update(){
        if let categorizedMessage = self.conversation.lastMessage as? IMCategorizedMessage {
            switch categorizedMessage {
                case is IMTextMessage:
                    self.convLastMessageContentText = categorizedMessage.text ?? "猜猜我说了什么?"
                default:
                    break
            }
        }
        self.convName = self.conversation.name ?? "神秘人的神秘对话"
        self.members = self.conversation.members?.stringValue ?? "一个大帅逼"
        self.time = self.conversation.lastMessage?.deliveredDate?.stringValue ?? "not from future"
    }
    init(conversation: IMConversation){
        self.conversation = conversation
    }
    
    var body: some View {
        HStack {
            Text(convName)
                .font(.title)
                .foregroundColor(Color.white)
                .frame(width: 60.0, height: 60.0, alignment: .center)
                .background(Color.blue)
                .cornerRadius(30.0)
            VStack(alignment:.leading) {
                Text(convName)
                    .font(.subheadline)
                Text(convLastMessageContentText)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text(time)
                    .font(.caption)
                Text("正在发生").font(.system(size: 14.0)) // 一些tag: 聊天状态-活跃 | 多少人在看 | 刚开始 | 男女 | 基友...
            }
        }.onAppear{
            self.update()
        }
    }
}
