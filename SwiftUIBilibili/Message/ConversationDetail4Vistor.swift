//
//  ConversationDetail4Vistor.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/30/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import URLImage
import LeanCloud

struct ConversationDetail4Vistor: View {
    
    var convId: String = ""
    @State var messageList = [MessageFromConvHistoryModel]()
    @State var convDetail = LCObject()
    @State var pairName = ""
    @EnvironmentObject var globalData: GlobalData
    
    func getConvInfo(){
        let query = LCQuery(className: "_Conversation")
        query.whereKey("objectId", .equalTo(convId))
        _ = query.getFirst{result in
            switch result {
                case .success(object: let convObj):
                    self.convDetail = convObj
                    if let pair:[String] = self.convDetail.get("m")!.arrayValue as? [String] {
                        self.pairName = pair[0] + " & " + pair[1]
                    }
                case .failure(error: let error):
                    print(error)
            }
        }
    }
    func getMessages(){
        let params = ["limit": "200"]
        LCRest.getConversationHistoryById(id: convId, params: params,callback: {section in
            self.messageList = section
            print("getMessages", self.messageList)
        })
    }
    var body: some View {
        VStack {
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
                                processors: [ Resize(size: CGSize(width: 100.0, height: 100.0), scale: UIScreen.main.scale) ],
                                content: {
                                    $0.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                            }).frame(width: 100.0,height: 100.0)
                            
                        }
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding()
                }
            }
        .navigationBarTitle(pairName)
        .onAppear{
            self.getConvInfo()
            self.getMessages()
        }
        .onDisappear{
            self.globalData.isShowBottomTab.toggle()
        }

    }
}

struct ConversationDetail4Vistor_Previews: PreviewProvider {
    static var previews: some View {
        ConversationDetail4Vistor()
    }
}
