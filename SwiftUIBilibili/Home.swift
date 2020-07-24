//
//  Home.swift
//  Ipadyou
//
//  Created by boo on 5/11/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct Home: View {
    
    @State var show = false // 当前组件的状态
    @State var showProfile = false // 是否显示DanceGround
    @EnvironmentObject var globalData: GlobalData
    
    
    var body: some View {
        NavigationView{
            ZStack() {
                VStack {
                    DanceGround()
                        .background(Color(UIColor(named: "BgColor")!))
                        .animation(.spring())
                        .environmentObject(globalData)
                }
            }
            .navigationBarTitle("广场", displayMode: .inline)
            .navigationBarItems(
                leading: MenuRight()
            )
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(GlobalData())
    }
}

struct Menu: Identifiable {
    var id = UUID()
    var title: String
    var icon: String
}


struct CircleButton: View {
    var icon = ""
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
        }
        .frame(width: 40, height: 40)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10, x: 0, y: 10)
    }
}

struct MenuRight: View {
    @State var show: Bool = false
    @EnvironmentObject var globalData: GlobalData
    
    let lc_user_email: String = LCApplication.default.currentUser?.email!.rawValue as? String ?? "No Email"
    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                if globalData.isLogged {
                    Button(action: {
                        self.show.toggle()
                    }){
//                        CircleButton(icon: "person.crop.circle")
                        Image(systemName: "person.crop.circle")
                    }
                    Text(lc_user_email)
                } else {
                    Button(action: {self.globalData.showLogin = true}){
                        Image(systemName: "person.crop.circle.badge.exclam")
                    }
                    Text("未登录").foregroundColor(Color.red)
                }
            }
            Spacer()
                .frame(minWidth:0,maxHeight: .infinity)
        }.actionSheet(isPresented: $show){
            ActionSheet(title:Text("操作"),buttons: [
                .destructive(Text("退出登录")){
                    LCUser.logOut()
                    UserDefaults.standard.set(false, forKey: "isLogged")
                    self.globalData.isLogged = false
                    self.show = false
                },
                .cancel()
            ])
        }
    }
}
