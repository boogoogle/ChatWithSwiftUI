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
    @EnvironmentObject var userData: UserStore
    
    
    var body: some View {
        ZStack() {
            NavigationView{
                VStack {
                    DanceGround()
                        .background(Color.white)
                        .animation(.spring())
                        .environmentObject(userData)
                }
            }
            .navigationBarTitle("广场")
            .navigationBarItems(
                leading: Button("left"){print("left clicked")},
                trailing:MenuRight(show: $showProfile)
            )
            
            
            

            if !userData.hideBottomCardAndMenuBtn {
                MenuRight(show: $showProfile)
                    .animation(.spring())
                    .offset(x: -30, y:showProfile ? 70 : 30)
            }
            if userData.showLogin {
                ZStack {
                    LoginView()
                    VStack {
                        HStack {
                            Spacer()
                            CircleButton(icon: "xmark")
                                .onTapGesture {
                                    self.userData.showLogin = false
                            }
                        }
                        Spacer()
                    }.padding()
                }
            } else {
                MenuView(show: $showProfile) // 通过 $符号实现双向数据绑定
            }
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(UserStore())
    }
}

struct MenuRow: View {
    var image = "creditcard"
    var text = ""
    var body: some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .frame(width: 32, height: 32) // 删掉边框,看看效果?
            Text(text)
                .font(.headline)
            Spacer()
        }
    }
}

struct Menu: Identifiable {
    var id = UUID()
    var title: String
    var icon: String
}

let menuData = [
//    Menu(title: "My Account", icon: "person.crop.circle"),
//    Menu(title: "Billing", icon: "creditcard"),
    Menu(title: "Cancel", icon: "arrow.turn.up.left"),
]

struct MenuView: View {
    var menu = menuData
    @Binding var show: Bool   // 从父组件监听状态的改变
    @EnvironmentObject var userData: UserStore
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(menu) { item in
                MenuRow(image: item.icon, text: item.title)
            }
            MenuRow(image: "arrow.uturn.down", text: "Sign out ")
                .onTapGesture {
                    LCUser.logOut()
                    UserDefaults.standard.set(false, forKey: "isLogged")
                    self.userData.isLogged = false
                    self.show = false
            }
            Spacer()
        }
        .padding(30)
        .padding(.top, 20)
        .frame(minWidth:0, maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
        .padding(.trailing, 60)
        .shadow(radius: 20)
        .rotation3DEffect(Angle(degrees: show ? 0 :30), axis: (x: 0, y: 10, z: 0)) // 这里axis的每个维度,值为1, 10, 100 没啥区别啊???
        .animation(.easeInOut) // 括号内是动画执行类型,
        .offset(x: show ? 0 : -MAINWIDTH)
        .onTapGesture {
            self.show.toggle()
        }
    }
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

struct MenuButton: View {
    @Binding var show: Bool
    var body: some View {
        ZStack(alignment:.topLeading) {
            Button(action: {self.show.toggle()}){
                HStack {
                    Spacer()
                    Image(systemName: "list.dash")
                        .foregroundColor(.black)
                }
                .frame(width: 90, height: 60)
                .padding(.trailing, 20)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 10, x: 0, y: 10)
            }
            Spacer()
                .frame(minWidth:0,maxHeight: .infinity)
        }
    }
}

struct MenuRight: View {
    @Binding var show: Bool
    @EnvironmentObject var userData: UserStore
    
    let lc_user_email: String = LCApplication.default.currentUser?.email!.rawValue as? String ?? "No Email"
    
    var body: some View {
        ZStack(alignment:.topTrailing) {
            HStack(alignment: .center) {
                if userData.isLogged {
                    Text(lc_user_email)
                    Button(action: {self.show.toggle()}){
                        CircleButton(icon: "person.crop.circle")
                    }
                } else {
                    Text("未登录")
                        .foregroundColor(Color.red)
                    Button(action: {self.userData.showLogin = true}){
                        CircleButton(icon: "person.crop.circle.badge.exclam")
                    }
                }
            }
            Spacer()
                .frame(minWidth:0,maxHeight: .infinity)
        }
    }
}
