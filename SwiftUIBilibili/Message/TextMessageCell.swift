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
    
    var body: some View {
        
        VStack(alignment: isSelf ? .trailing : .leading ) {
            Text(message.fromClientID ?? "-")
                .font(.system(size: 14))
            Text(message.text ?? "-")
                .font(.system(size: 12))
        }
        
    }
}

//struct TextMessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TextMessageCell()
//    }
//}
