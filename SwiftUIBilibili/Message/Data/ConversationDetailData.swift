//
//  ConversationDetailData.swift
//  Ipadyou
//
//  Created by Boo on 5/18/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import Combine
import LeanCloud

final class ConversationDetailData: ObservableObject {
//    @Published var typingMessage: String = "说点什么吧"
    @Published var messages = [IMMessage]()
}

