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
    
    let params = ["limit": "200"]
    func getConvInfo(){
        dPrint("getConvInfo---")
        let query = LCQuery(className: "_Conversation")
        query.whereKey("objectId", .equalTo(convId))
        _ = query.find{result in
            switch result {
                case .success(objects: let convObjList):
                    guard convObjList.count > 0 else {
                        print("未查询到对话\(self.convId)详情: \(convObjList.count)")
                        break
                    }
                    self.convDetail = convObjList[0]
                    if let pair:[String] = self.convDetail.get("m")!.arrayValue as? [String] {
                        self.pairName = pair[0] + " & " + pair[1]
//                        print("888888",self.pairName, pair)
                    }
                case .failure(error: let error):
                    print(error)
            }
        }
    }
    func getMessages(){
        LCRest.getConversationHistoryById(id: convId, params: params,callback: {section in
            self.messageList = section
        })
    }
    var body: some View {
        VStack {
            VStack{
                Text("\(pairName)").font(.title)
//                Text("\(convId)")
            }
            
            ScrollView{
                ForEach(messageList, id: \.msgId){ m in
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
                .frame(maxWidth: .infinity)
                .padding()
            }
            }
        }.onAppear{
            
        }.onAppear{
            self.getConvInfo()
            self.getMessages()
        }
        
        
    }
}

struct ConversationDetail4Vistor_Previews: PreviewProvider {
    static var previews: some View {
        ConversationDetail4Vistor()
    }
}
