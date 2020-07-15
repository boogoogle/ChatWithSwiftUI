//
//  DanceGroundQuickConvCard.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/24/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import URLImage
import Foundation

struct DanceGroundQuickConvCard: View {
    var messageList: [MessageFromConvHistoryModel]
    
    var body: some View {
        VStack(alignment: .leading){
            List(messageList, id: \.msgId){ m in
                HStack(alignment: .top) {
                    Text("\(m.from):")
                        .font(.subheadline)

                    if m.lcType == -1 {
                        Text(m.lcText)
                            .font(.body)
                    }
                    if (m.imgUrl != ""){
                        URLImage(
                            URL(string: m.imgUrl)!,
                            processors: [ Resize(size: CGSize(width: 80.0, height: 80.0), scale: UIScreen.main.scale) ],
                            placeholder: { _ in
                                Text("loading")
                            },
                            content: {
                                $0.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                            }
                        ).frame(width: 100.0,height: 100.0)
                        
                    }
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
        .onAppear{
            print(self.messageList[1].imgUrl, "1111")
        }
    }
}


#if DEBUG
let msg = MessageFromConvHistoryModel(
    msgId: "fpg66+29QiiegpFTuGyW7Q",
    convId: "5eef00a10d3a42c5fda6b448",
    timestamp: "1592813212675",
    lcText: "How are you how are you,",
    from: "Boo@B.b",
    imgUrl: "http://lc-fnjUKhQv.cn-n1.lcfile.com/9e07f0754c0944e6ab1bce164e005610",
    lcType: -2// -1文本, -2图片
)

var list : [MessageFromConvHistoryModel] = [msg, msg,msg,msg,msg]

struct DanceGroundQuickConvCard_Previews: PreviewProvider {
    static var previews: some View {
        DanceGroundQuickConvCard(messageList: list)
    }
}
#endif
