//
//  NormalConversationModel.swift
//  Ipadyou
//
//  Created by boo on 5/8/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct NormalConversationModel: Hashable,Codable,Identifiable {
    var id: Int
    var avatar: String
    var text: String
    var pairs: String
    var timeStamp: String
}

