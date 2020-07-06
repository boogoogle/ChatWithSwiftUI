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
    @State var unreadCount = 0
    
    func update(){
        if let categorizedMessage = self.conversation.lastMessage as? IMCategorizedMessage {
            switch categorizedMessage {
                case is IMTextMessage:
                    self.convLastMessageContentText = categorizedMessage.text ?? "猜猜我说了什么?"
                case is IMImageMessage:
                    convLastMessageContentText = categorizedMessage.text ?? "[Image]"
                default:
                    break
            }
        }
        self.convName = self.conversation.name ?? "神秘人的神秘对话"
        self.members = self.conversation.members?.stringValue ?? "一个大帅逼"
        self.time = self.conversation.lastMessage?.deliveredDate?.stringValue ?? "not from future"
        self.unreadCount = self.conversation.unreadMessageCount
    }
    init(conversation: IMConversation){
        self.conversation = conversation
    }
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                Text(self.convName)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .frame(width: 60.0, height: 60.0, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(30.0)
                if self.unreadCount > 0 {
                    Text("\(self.unreadCount)")
                        .bold()
                        .foregroundColor(Color.red)
                        .offset(x:geometry.size.width - 8, y: -4)
                }
            }.frame(width: 60,height: 60)
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

//struct NormalConversationListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NormalConversationListCell()
//    }
//}
