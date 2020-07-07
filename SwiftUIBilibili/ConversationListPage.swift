//
//  CreateConversation.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/21/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct ConversationListPage: View {
    @State var friendEmail: String = ""
    @State var showDetail: Bool = false
    @State var convsersationDetail = ConversationDetail()
    @EnvironmentObject var globalData: GlobalData
    
    let screenHeight = UIScreen.main.bounds.height
    
    func createNormalConversation(){
        print("createNormalConversation -- start")
        var memberSet = Set<String>()
        memberSet.insert(LCClient.current.ID)
        memberSet.insert(friendEmail)
        guard memberSet.count > 1 else {
            return
        }
        
        let name: String = {
            let sortedNames: [String] = memberSet.sorted()
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
                        LCClient.currentConversation = conversation
                        self.showDetail = true
                        print("showDetail", self.showDetail)
                    case .failure(error: let error):
                        print(error)
                        break
                }
            })
        }catch {
            print("\(error)")
        }
    }
    
    var body: some View {
            VStack() {
                VStack(alignment: .leading){
                    Text("未读消息: \(self.globalData.unreadMessageCount)")
                    // TODO 需要改成EnviromentObject,现在不能实时更新啊
                    if self.globalData.currentConversationList.count > 0 {
                        List(self.globalData.currentConversationList , id: \.ID) { conv in
                            NormalConversationListCell(conversation: conv)
                                .onTapGesture {
                                    LCClient.currentConversation = conv
                                    self.showDetail = true
                            }
                            .id(UUID()) // 在这里加上id属性,会导致每一条列表项都会刷新一下,不大好,不过暂时没啥好办法
                        }
                    }
                }
                
                Text("和朋友荡起双桨?")
                HStack {
                    TextField("输入对方id畅所欲言", text: $friendEmail)
                    Button(action:{
                        self.createNormalConversation()
                    }){
                        Text("发起").foregroundColor(.blue)
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
    }
}
