//
//  GlobalData.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/3/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

final class GlobalData: ObservableObject {
    @Published var unreadMessageCount = 0
    @Published var currentConversationList = [IMConversation]()
    @Published var isShowBottomTab = true
}
