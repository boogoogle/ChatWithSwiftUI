//
//  NormalConversationListCell.swift
//  Ipadyou
//
//  Created by boo on 5/8/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct NormalConversationListCell: View {
    var conversation: NormalConversationModel
    
    
    var body: some View {
        HStack {
            Text(conversation.avatar)
                .font(.title)
                .foregroundColor(Color.white)
                .frame(width: 60.0, height: 60.0, alignment: .center)
                .background(Color.blue)
                .cornerRadius(30.0)
            VStack(alignment:.leading) {
                Text(conversation.pairs)
                    .font(.title)
                Text(conversation.text)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text(conversation.timeStamp)
                    .font(.caption)
                Text("正在发生") // 聊天状态-活跃 | 多少人在看 | 刚开始 | 男女 | 基友...
            }
        }
    }
}
