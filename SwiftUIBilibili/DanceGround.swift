//
//  DanceGround.swift
//  Ipadyou
//
//  Created by boo on 5/6/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct DanceGround: View {
    @State var viewState = CGSize.zero // CG -> Core Graphics
    @State var conversations = [IMConversation]()
    @State var convObjList = [LCObject]()
    @State var showConvDetail = false
    
    @EnvironmentObject var viewModel: UserStore
    
    func getConversations(){
        let query = LCQuery(className: "_Conversation")
        _ = query.find{result in
            switch result {
                case .success(objects: let convObjList):
                    self.convObjList = convObjList
                    self.updateConvList()
                case .failure(error: let error):
                    print(error)
            }
        }
    }
    func updateConvList(){
        for conv in self.convObjList {
            let convId = conv.objectId!.rawValue as! String
            // 使用Conversation的id获取最新的几条消息
            LCRest.getConversationHistoryById(id: convId,callback: {list in
                self.viewModel.convHistoryGroup.append(list)
            })
        }
    }
    
    var body: some View {
        ZStack {
//            TitleView()
            if viewModel.convHistoryGroup.count > 0 {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        // numbered()是后期扩展的; 后面的id,必须用.element.xxx
                        ForEach(viewModel.convHistoryGroup.numbered(), id: \.element.self) { (num, msgList) in
                            VStack{
                                DanceGroundQuickConvCard(messageList: msgList)
                                    .gesture(TapGesture().onEnded{
                                        self.viewModel.hideBottomCardAndMenuBtn = true
                                        self.showConvDetail = true
                                    })
                            }
                        }
                        
                    }.padding(20)
                }
            }
            if !viewModel.hideBottomCardAndMenuBtn {
                DanceGroundBottomCardView().animation(.easeInOut)
            }
        }
        .onAppear{
            self.getConversations()
        }.sheet(isPresented: $showConvDetail, onDismiss: {
            self.viewModel.hideBottomCardAndMenuBtn = false
        }){
            ConversationDetail4Vistor()
        }
    }
}

//struct DanceGround_Previews: PreviewProvider {
//    @State var s = false
//    static var previews: some View {
//        DanceGround(hideFlag: $s)
//    }
//}

struct CardView: View {
    @Binding var messageList: [MessageFromConvHistoryModel]

    var body: some View {
        VStack(){
            ForEach(messageList, id: \.msgId){ m in
                Text(m.lcText)
            }
        }
        .frame(width: 300.0, height: 220.0)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

struct TitleView: View {
    var body: some View {
        VStack{
            Text("Amazing happening")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Spacer()
        }
    }
}


