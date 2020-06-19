//
//  MessageInputer.swift
//  Ipadyou
//
//  Created by boo on 5/7/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

//protocol MessageInputerDelegate: View{
//
//    func messageInputer(didFinishInput message: IMMessage)
//}

struct MessageInputer: View {
    @Binding var textMessage: String
    @Binding var isFocus: Bool
    @EnvironmentObject private var cdd: ConversationDetailData
    
    
    func hideKeyboard(){
        /**
         通过将target设置为nil，让系统自动遍历响应链
         从而响应链当前第一响应者响应我们自定义的方法"
         */
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func ensure(){
        print(self.$textMessage)
        let imTextMessage = IMTextMessage(text: self.textMessage)
        self.cdd.sendMsg(message: imTextMessage)

    }
    var body: some View {
        HStack {
            TextField("Say Hi", text: $textMessage)
                .padding(.leading, 5.0)
                .frame(height: 40.0)
                .foregroundColor(Color.green)
                .onTapGesture {
                    self.isFocus = true
            }
            Button(action: {
                self.isFocus = false
                self.hideKeyboard()
                self.ensure()
            }) {
                Text("Send")
            }
            .padding(.horizontal, 8.0)
            .frame(height: 40.0)
            .background(Color.blue)
            .foregroundColor(Color.white)
        }
        .padding(8.0)
    }
}
//
//struct MessageInputer_Previews: PreviewProvider {
//    private var s: String
//    static var previews: some View {
////        MessageInputer(textMessage: s)
//    }
//}
