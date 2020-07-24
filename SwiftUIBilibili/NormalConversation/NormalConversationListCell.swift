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
    
    
    // 不能添加@State, 因为@State标志并初始化的属性,会在init后执行
    var convLastMessageContentText: String = ""
    var convName = ""
    var members = ""
    var time = ""
    var unreadCount = 0
    
    
    init(conversation: IMConversation){
        self.conversation = conversation
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
    
    var body: some View {
        HStack(alignment: .center) {
            GeometryReader { geometry in
                Text(self.convName)
                    .font(.body)
                    .foregroundColor(Color.white)
                    .frame(width: 40.0, height: 40.0, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(20.0)
                if self.unreadCount > 0 {
                    Text("\(self.unreadCount)")
                        .font(.system(size: 12))
                        .bold()
                        .foregroundColor(Color.red)
                        .offset(x:geometry.size.width - 8, y: -5)
                }
            }.frame(width: 40,height: 40)
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
        }
    }
}

//struct NormalConversationListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NormalConversationListCell()
//    }
//}
