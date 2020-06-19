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
    
    var conversation: IMConversation!
    let uuid = UUID().uuidString
    
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
            VStack {
                Text(conversation.name ?? "_")
//                TextMessageCell()
                VStack{
                    Text("消息数目: \(self.conversationDetainData.messages.count)")
                }
                
                Spacer()
                MessageInputer(textMessage: $textMsg, isFocus: $isInputerFocus).environmentObject(self.conversationDetainData)
            }
        }.onTapGesture {
            self.isInputerFocus = false
            self.hideKeyboard()
        }
        .offset(y: isInputerFocus ? -300 : 0)
    }
}

//struct ConversationDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationDetail()
//        .environmentObject(ConversationDetailData())
//    }
//}
