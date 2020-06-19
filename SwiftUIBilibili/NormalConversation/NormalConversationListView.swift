//
//  NormalConversationListView.swift
//  Ipadyou
//
//  Created by boo on 5/8/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct NormalConversationListView: View {
    var body: some View {
        NavigationView {
            List(conversationListData) {conversation in
                NavigationLink(destination: ConversationDetail()){
                    NormalConversationListCell(conversation: conversation)
                }
            }
            .navigationBarTitle(Text("Dance Ground"))
        }
    }
}

struct NormalConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        NormalConversationListView()
    }
}
