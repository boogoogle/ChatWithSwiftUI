//
//  UserStore.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/17/20.
//  Copyright © 2020 boo. All rights reserved.
//

import LeanCloud
import SwiftUI
// 用来保存用户数据,几乎等同于Combine

import SwiftUI
import Combine

class UserStore: ObservableObject {
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
}

