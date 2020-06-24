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
        HStack(alignment: isSelf ? .top : .bottom) {
            
            if !isSelf {
                Text("Ta")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .frame(width: 60.0, height: 60.0, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(30.0)
                
            }
            
            if isSelf {
                 Spacer()
            }
            VStack(alignment: isSelf ? .trailing : .leading ) {
                Text(message.fromClientID ?? "-")
                    .font(.title)
                Text(message.text ?? "-")
            }
            if !isSelf {
                Spacer()
            }
            if isSelf {
                Text("Me")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .frame(width: 60.0, height: 60.0, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(30.0)
                
            }
        }
    }
}

//struct TextMessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TextMessageCell()
//    }
//}
