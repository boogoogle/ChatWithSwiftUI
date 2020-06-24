//
//  DanceGroundQuickConvCard.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/24/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct DanceGroundQuickConvCard: View {
    var messageList: [MessageFromConvHistoryModel]
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(messageList, id: \.msgId){ m in
                HStack() {
                    Text("\(m.from):")
                        .font(.subheadline)
                    Text(m.lcText)
                        .font(.title)
                }.foregroundColor(.white)
            }
        }
        .frame(width: 300.0, height: 220.0)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}


#if DEBUG
let msg = MessageFromConvHistoryModel(
    msgId: "fpg66+29QiiegpFTuGyW7Q",
    convId: "5eef00a10d3a42c5fda6b448",
    timestamp: "1592813212675",
    lcText: "How are you, you and you.",
    from: "Boo@B.b")

var list : [MessageFromConvHistoryModel] = [msg, msg,msg,msg,msg]

struct DanceGroundQuickConvCard_Previews: PreviewProvider {
    static var previews: some View {
        DanceGroundQuickConvCard(messageList: list)
    }
}
#endif
