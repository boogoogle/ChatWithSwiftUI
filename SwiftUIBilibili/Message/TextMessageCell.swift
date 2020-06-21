//
//  TextMessageCell.swift
//  Ipadyou
//
//  Created by boo on 5/7/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct TextMessageCell: View {
    var message: IMTextMessage
    var isSelf: Bool
    
    init(message: IMTextMessage) {
        self.message = message
        self.isSelf = LCApplication.default.currentUser?.email?.stringValue == message.fromClientID!.stringValue
    }
    
    var body: some View {
        HStack {
            self.isSelf ? Text("他说")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(30.0) : nil
            
            VStack(alignment: isSelf ? .leading : .trailing) {
                Text(message.fromClientID ?? "-")
                    .font(.title)
                Text(message.text ?? "-")
            }
            !self.isSelf ? Text("我说")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(30.0) : nil
        }
    }
}

//struct TextMessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TextMessageCell()
//    }
//}
