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
    @State var selectedConvId = ""
    
    @EnvironmentObject var viewModel: UserStore
    
    
    // 刚进入页面,获取第一组conversation
    func getConversations(){
        let params: Dictionary<String, LCValue> = ["limit": LCNumber(5)]
        
        LCQueryService.getConversations(params, {result in
            self.convObjList = result
            self.getConvMessages(result)
        })
    }
    func getConvMessages(_ convGroup: [LCObject]){
        
        for conv in convGroup {
            let convId = conv.objectId!.rawValue as! String
            // 使用Conversation的id获取最新的几条消息
            let params = ["limit":"6"]
            LCRest.getConversationHistoryById(id: convId, params: params, callback: {list in
                self.viewModel.convHistoryGroup.append(list)
            })
        }
    }
    
    func getMoreConversation(){
        let lastConvCreatedAt = (self.convObjList.last?.createdAt)!
        let params:Dictionary<String, LCValue> = ["lastConvCreatedAt": LCDate(lastConvCreatedAt)]
        
        LCQueryService.getConversations(params, {result in
            self.getConvMessages(result)
        })
    }
    
    var body: some View {
        ZStack {
            Color(UIColor(named: "BgColor")!).edgesIgnoringSafeArea(.all)
            if viewModel.convHistoryGroup.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        // numbered()是后期扩展的; 后面的id,必须用.element.xxx
                        ForEach(viewModel.convHistoryGroup.numbered(), id: \.element.self) { (num, msgList) in
                            VStack{
                                if msgList.count > 0 {
                                    NavigationLink(destination:  ConversationDetail4Vistor(convId: msgList[0].convId)) {
                                        DanceGroundQuickConvCard(messageList: msgList)
                                    }
                                }
                            }
                        }
                        Button(action: {
                            self.getMoreConversation()
                        }){
                            Text("更多")
                        }
                        
                    }.frame(maxHeight: .infinity)
                }
            }
        }
        .onAppear{
            self.getConversations()
        }
        .sheet(isPresented: $showConvDetail){
            ConversationDetail4Vistor(convId: self.selectedConvId)
        }
    }
}

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


