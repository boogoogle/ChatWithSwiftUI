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
    @State var selectedConversation: IMConversation?
    
    let screenHeight = UIScreen.main.bounds.height
    
    func createNormalConversation(){
        print("createNormalConversation -- start")
        if self.friendEmail == "" {
            self.toastText = "请输入对方Email!"
            self.isShowingToast = true
            return
        }
        var memberSet = Set<String>()
        memberSet.insert(LCClient.currentIMClient.ID)
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
            try LCClient.currentIMClient.createConversation(clientIDs: memberSet, name: name, completion: {(result) in
                switch result {
                    case .success(value: let conversation):
                        self.selectedConversation = conversation
                        self.isShowSheet = false
                        mainQueueExecuting {
                            self.globalData.isShowBottomTab = false
                        }
                        
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
                            if self.globalData.currentConversationList.count > 0 {
                                List(self.globalData.currentConversationList , id: \.ID) { conv in
                                    NavigationLink(destination: ConversationDetail(conversation:conv).environmentObject(ConversationDetailData())){
                                        NormalConversationListCell(conversation: conv)
                                    }

                                    
                                }
                            }
                            
                            // 新建对话后,跳转到的对话详情页
                            NavigationLink(destination: ConversationDetail(conversation:self.selectedConversation).environmentObject(ConversationDetailData()),
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
            }.onAppear{
                self.globalData.isShowBottomTab = true
        }
    }
}
