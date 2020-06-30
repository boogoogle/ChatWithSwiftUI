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
                HStack(alignment: .top) {
                    Text("\(m.from):")
                        .font(.subheadline)
                    Text(m.lcText)
                        .font(.body)
                    Spacer()
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
            }
            Spacer()
        }
        .frame(width: 280.0, height: 420.0)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}


#if DEBUG
let msg = MessageFromConvHistoryModel(
    msgId: "fpg66+29QiiegpFTuGyW7Q",
    convId: "5eef00a10d3a42c5fda6b448",
    timestamp: "1592813212675",
    lcText: "How are you how are you,",
    from: "Boo@B.b")

var list : [MessageFromConvHistoryModel] = [msg, msg,msg,msg,msg]

struct DanceGroundQuickConvCard_Previews: PreviewProvider {
    static var previews: some View {
        DanceGroundQuickConvCard(messageList: list)
    }
}
#endif
