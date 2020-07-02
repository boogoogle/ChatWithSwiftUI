//
//  BottomTabView.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/2/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        TabView {
            Home().tabItem{
                Image(systemName: "person.3.fill")
                Text("广场")
            }
            MyConversations().tabItem {
                Image(systemName: "quote.bubble.fill")
                Text("我的")
            }
        }
    }
}

struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
    }
}
