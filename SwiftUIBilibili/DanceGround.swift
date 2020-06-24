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
    @State var show = false
    @State var viewState = CGSize.zero // CG -> Core Graphics
    @State var conversations = [IMConversation]()
    @State var convObjList = [LCObject]()
    
    @EnvironmentObject private var viewModel: DanceGroundData
    
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
                // 用循环不好做啊,怎么拿索引???
//                VStack {
//                    ForEach(viewModel.convHistoryGroup, id: \.self) { (msgList) in
//                        DanceGroundQuickConvCard(messageList: msgList)
//
//                    }
//                }
                
                DanceGroundQuickConvCard(messageList: viewModel.convHistoryGroup[0])
            }
            if viewModel.convHistoryGroup.count > 1{
                DanceGroundQuickConvCard(messageList: viewModel.convHistoryGroup[1])
                    .offset(x: 20,y: 40)
            }
            
            if viewModel.convHistoryGroup.count > 2{
                DanceGroundQuickConvCard(messageList: viewModel.convHistoryGroup[2])
                    .offset(x: 40,y: 80)
            }
            
//            CardView(messageList: $viewModel.convHistoryGroup[1])
            //                    .blendMode(.darken)
            
//            CardView()
//                .offset(x: 0, y: -20)
//                .scaleEffect(0.9)
//                .rotationEffect(Angle(degrees: 10))
//                .rotation3DEffect(Angle(degrees: 40), axis: (x: 10.0, y: 10.0, z: 10.0))
//                .blendMode(.darken)
                
//            CertificateView()
//                .offset(x: viewState.width, y: viewState.height)
//                .scaleEffect(0.95)
//                .rotationEffect(Angle(degrees: show ? 5 : 0))
//                .rotation3DEffect(Angle(degrees: show ? 30 : 0), axis: (x: 10.0, y: 10.0, z: 10.0))
//                .blendMode(.darken)
//                .animation(.default) // .spring()
//                .onTapGesture {
//                    self.show.toggle()
//                }
//                .gesture(
//                    DragGesture()
//                        .onChanged({ (value) in
//                            self.viewState = value.translation
//                        })
//                        .onEnded({ value in
//                            self.viewState = CGSize.zero
////                            self.show = false
//                        })
//                )
            DanceGroundBottomCardView()
        }
        .onAppear{
            self.getConversations()
        }
    }
}

struct DanceGround_Previews: PreviewProvider {
    static var previews: some View {
        DanceGround()
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

struct CertificateView: View {
    var body: some View {
        VStack() {
            HStack {
                VStack(alignment: .leading) {
                    Text("People are dancing!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                    Text("What was discussing?")
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding(8.0)
                .frame(width: 320.0,height: 220.0)
                .background(Color.black)
                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                .shadow(radius: 8.0)
            }
        }
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


