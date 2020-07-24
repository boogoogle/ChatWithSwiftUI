//
//  GlobalData.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/3/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud
import Combine

class GlobalData: ObservableObject {
    @Published var unreadMessageCount = 0
    @Published var currentConversationList = [IMConversation]()
    @Published var isShowBottomTab = true
    
    @Published var isLogged: Bool = UserDefaults.standard.bool(forKey: "isLogged") {
        didSet {
            if LCApplication.default.currentUser != nil {
                UserDefaults.standard.set(self.isLogged, forKey: "isLogged")
            } else {
                UserDefaults.standard.set(false, forKey: "isLogged")
            }
            
        }
    }
    @Published var showLogin = false
    @Published var convHistoryGroup = [[MessageFromConvHistoryModel]]()
}
