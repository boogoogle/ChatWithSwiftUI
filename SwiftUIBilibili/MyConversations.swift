//
//  MyConversations.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/2/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct MyConversations: View {
    var body: some View {
        ConversationListPage().animation(.easeInOut)
    }
}

struct MyConversations_Previews: PreviewProvider {
    static var previews: some View {
        MyConversations()
    }
}
