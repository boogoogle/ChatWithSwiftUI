//
//  TextMessageCell.swift
//  Ipadyou
//
//  Created by boo on 5/7/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct TextMessageCell: View {
    var isSelf: Bool = false
    var msgText: String = ""
//    var msg: MessageModel
    
    var body: some View {
        HStack {
            isSelf ? Text("Avatar")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(30.0) : nil
            
            VStack(alignment: isSelf ? .leading : .trailing) {
                Text("Boo")
                    .font(.title)
                Text(msgText)
            }
            !isSelf ? Text("Avatar")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(30.0) : nil
        }
    }
}

struct TextMessageCell_Previews: PreviewProvider {
    static var previews: some View {
        TextMessageCell()
    }
}
