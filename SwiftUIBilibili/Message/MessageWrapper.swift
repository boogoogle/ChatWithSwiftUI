//
//  MessageWrapper.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/28/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud
import URLImage

struct MessageWrapper: View {
    var message: IMMessage
    var isSelf: Bool
    var isImageMessage: Bool = false
    
    init(_ message: IMMessage) {
        self.message = message
//        self.isSelf = LCApplication.default.currentUser?.email?.stringValue == message.fromClientID!.stringValue
        self.isSelf = message.ioType == .out
        if ((message as? IMImageMessage) != nil) {
            self.isImageMessage = true
        }
    }
    
    var body: some View {
        HStack(alignment: isSelf ? .top : .bottom) {
            
            if !isSelf {
                Text("Ta")
                    .font(.body)
                    .foregroundColor(Color.white)
                    .frame(width: 40.0, height: 40.0, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(20.0)
                
            }
            
            if isSelf {
                Spacer()
            }
            
            if isImageMessage {
                ImageMessageCell(message: message as! IMImageMessage)
            } else {
                TextMessageCell(message: message as! IMTextMessage, isSelf: isSelf)
            }
            if !isSelf {
                Spacer()
            }
            if isSelf {
                Text("Me")
                    .font(.body)
                    .foregroundColor(Color.white)
                    .frame(width: 40.0, height: 40.0, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(20.0)
                
            }
        }
    }
}



#if DEBUG

let message = IMImageMessage()


struct MessageWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MessageWrapper(message as IMMessage)
    }
}
#endif
