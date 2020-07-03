//
//  BottomTabView.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/2/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct BottomTabView: View {
    @EnvironmentObject var globalData: GlobalData
    func initIMClient(){
        do {
            let clientId: String = LCApplication.default.currentUser?.email!.rawValue as? String ?? ""
            if clientId != ""{
                print("initIMClient, 当前登录用户的Email是: ", clientId)
            }
            let client = try IMClient(
                ID: clientId,
                delegate: LCClient.delegator,
                eventQueue: LCClient.queue
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
        TabView {
            Home().tabItem{
                Image(systemName: "person.3.fill")
                Text("广场")
            }
            MyConversations()
            .tabItem {
                Image(systemName: "quote.bubble.fill")
                Text("我的 \(globalData.unreadMessageCount)")
            }
        }.onAppear{
            self.initIMClient()
        }
    }
}
