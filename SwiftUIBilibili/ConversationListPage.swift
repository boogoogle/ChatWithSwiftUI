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
    @State var isShowSheet: Bool = false
    @State var selectionRouterView: Int? = nil
    @EnvironmentObject var globalData: GlobalData
    
    @State var isShowingToast = false
    @State var toastText = ""
    
    let screenHeight = UIScreen.main.bounds.height
    
    func createNormalConversation(){
        print("createNormalConversation -- start")
        if self.friendEmail == "" {
            self.toastText = "请输入对方Email!"
            self.isShowingToast = true
            return
        }
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
                        self.isShowSheet = false
                        self.selectionRouterView = 2
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
                NavigationView {
                    VStack {
                        VStack(alignment: .leading){
                            //                        Text("未读消息: \(self.globalData.unreadMessageCount)")
                            if self.globalData.currentConversationList.count > 0 {
                                List(self.globalData.currentConversationList , id: \.ID) { conv in
                                    NavigationLink(destination: ConversationDetail(conversation:conv).environmentObject(ConversationDetailData())){
                                        NormalConversationListCell(conversation: conv)
                                    }
                                }.id(UUID()) // 在这里加上id属性,会导致每一条列表项都会刷新一下,不大好,不过暂时没啥好办法; 不要加到内部条目上!
                                // 可以 [参考](https://www.hackingwithswift.com/articles/210/how-to-fix-slow-list-updates-in-swiftui)
                            }
                            NavigationLink(destination: ConversationDetail(conversation:LCClient.currentConversation).environmentObject(ConversationDetailData()),
                                           tag: 2, selection: self.$selectionRouterView
                            ){
                                Text("NavigationLink4CreateConversation").opacity(0.0).frame(width:0,height:0)
                            }
                        }
                    }
                    .navigationBarTitle("我的消息", displayMode: .inline)
                    .navigationBarHidden(false)
                    .navigationBarItems(trailing:
                        Image(systemName: "plus.circle")
                        .onTapGesture {
                            self.isShowSheet = true
                        }
                        .sheet(isPresented: $isShowSheet){
                            VStack{
                                Text("和朋友荡起双桨?")
                                HStack {
                                    TextField("输入对方id畅所欲言", text: self.$friendEmail)
                                    Button(action:{
                                        self.createNormalConversation()
                                    }){
                                        Text("发起").foregroundColor(.blue)
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .toast(isShowing: self.$isShowingToast, text: Text(self.toastText))
                            
                        }
                    )
                
                }
                .frame(minWidth: 0, maxWidth: .infinity) // 使之宽度全屏
                .background(Color.white)// 这里不设置background,下面的shadow看不出来
            }
    }
}
