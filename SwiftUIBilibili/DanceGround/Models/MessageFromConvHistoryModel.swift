//
//  MessageModel.swift
//  Ipadyou
//
//  Created by boo on 5/8/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
/**
    首页显示的聊天列表, 根据convsationID获取message history, ,需要rest接口获取,
        获取到的message 数据类型和 IMMessage不一样
        所以在此处重新定义一份
 */
struct MessageFromConvHistoryModel: Hashable {
    var msgId: String
    var convId: String
    var timestamp: String
    var lcText: String
    var from: String
    var imgUrl: String
    var lcType: Int
}

