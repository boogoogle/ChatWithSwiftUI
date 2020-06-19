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
    
    var body: some View {
        ZStack {
            TitleView()
            
            CardBottomView()
            
            CardView()
                .offset(x: 0, y: -40)
                .scaleEffect(0.85)
                .rotationEffect(Angle(degrees: 15.0))
                .rotation3DEffect(Angle(degrees: 50), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.darken)
            CardView()
                .offset(x: 0, y: -20)
                .scaleEffect(0.9)
                .rotationEffect(Angle(degrees: 10))
                .rotation3DEffect(Angle(degrees: 40), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.darken)
                
            CertificateView()
                .offset(x: viewState.width, y: viewState.height)
                .scaleEffect(0.95)
                .rotationEffect(Angle(degrees: show ? 5 : 0))
                .rotation3DEffect(Angle(degrees: show ? 30 : 0), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.darken)
                .animation(.default) // .spring()
                .onTapGesture {
                    self.show.toggle()
                }
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            self.viewState = value.translation
                        })
                        .onEnded({ value in
                            self.viewState = CGSize.zero
//                            self.show = false
                        })
                )
        }
    }
}

struct DanceGround_Previews: PreviewProvider {
    static var previews: some View {
        DanceGround()
    }
}

struct CardView: View {
    var body: some View {
        VStack(){
            Text("Card Back")
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
            Text("Cettificates")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Spacer()
        }
    }
}

struct CardBottomView: View {
    @State var friendEmail: String = "B@b.b"
    @State var showDetail: Bool = false
//    @EnvironmentObject var conversationDetailData: ConversationDetailData
    @State var convsersationDetail = ConversationDetail()
    
    func createNormalConversation(){
        var memberSet = Set<String>()
        memberSet.insert(LCClient.current.ID)
        memberSet.insert(friendEmail)
        guard memberSet.count > 1 else {
            return
        }
        
        let name: String = {
            let sortedNames: [String] = memberSet.sorted(by: { $0 < $1 })
            let name: String
            if sortedNames.count > 3 {
                name = [sortedNames[0], sortedNames[1], sortedNames[2], "..."].joined(separator: " & ")
            } else {
                name = sortedNames.joined(separator: " & ")
            }
            return name
        }()
        
        do {
            try LCClient.current.createConversation(clientIDs: memberSet, name: name, completion: {(result) in
                switch result {
                    case .success(value: let conversation):
//                        let messageListVc = MessagePort
                        print(conversation,"conversation---")
                        // 通过直接传参,全局保存, 哪种方式好呢?
                        self.convsersationDetail.conversation = conversation
                        LCClient.currentConversation = conversation
                        self.showDetail = true
                    case .failure(error: let error):
                        print(error)
                        break
                }
            })
        }catch {
            print("\(error)")
        }
        
        
        
    }
    
    func initIMClient(){
        do {
            let clientId: String = LCApplication.default.currentUser?.email!.rawValue as? String ?? ""
            if clientId != ""{
                print("initIMClient, 当前登录用户的Email是: ", clientId)
            }
            let client = try IMClient(
                ID: clientId
            )
            self.open(client: client)
        } catch {
            print(error)
        }
        
    }
    func open(client: IMClient){
        print("open")
        client.open { (result) in
            print("IMClient open 结果",result)
            switch result {
                case .success:
                    LCClient.current = client
                    break
                case .failure(error: let error):
                    print(error)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20.0) {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
            
            Text("来擦火花滋人")
            
            HStack {
                TextField("输入对方id", text: $friendEmail)
                Button(action:{
                    self.createNormalConversation()
                }){
                    Text("确定")
                }.sheet(isPresented: $showDetail){
                    self.convsersationDetail.environmentObject(ConversationDetailData())
                }
            }
            
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity) // 使之宽度全屏
        .padding()
        .padding(.horizontal)
        .background(Color.white)// 这里不设置background,下面的shadow看不出来
        .cornerRadius(30)
        .shadow(radius: 20)
        .offset(y: 600)
            .onAppear(){
                self.initIMClient()
        }
    }
}
