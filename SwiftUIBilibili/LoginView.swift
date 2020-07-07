//
//  LoginView.swift
//  QWScreenReplay
//
//  Created by Boo on 6/16/20.
//  Copyright © 2020 xdw. All rights reserved.
//

import SwiftUI
import LeanCloud

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isFocused = false
    @State var showAlert = false
    @State var alertMessage = "Something went wrong."
    @State var isLoading = false
    @State var isSuccessful = false
    @State var isSignUp = false
    @EnvironmentObject var user: UserStore
    
    func hideKeyboard(){
        /**
          通过将target设置为nil，让系统自动遍历响应链
          从而响应链当前第一响应者响应我们自定义的方法"
         */
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func login() {
        self.hideKeyboard()
        self.isFocused = false
        self.isLoading = true
        
        print("login LeanCloud")
        _ = LCUser.logIn(email: self.email, password: self.password) { result in
            switch result {
                case .success(object: let lcuser):
                    print("lcuser -->",lcuser)
                    self.resetLogin()
                    self.user.isLogged = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isSuccessful = false
                        self.resetLogin()
                        self.user.showLogin = false
                        if let u = LCApplication.default.currentUser {
                            print("uuuuu", u.email!.rawValue)
                        }
                    }
                case .failure(error: let error):
                    print(error)
            }
        }
          
    }
    func signup(){
        self.hideKeyboard()
        self.isFocused = false
        self.isLoading = true
        
        print("signup LeanCloud")
        do {
            // 创建实例
            let user = LCUser()
            
            // 因为leancloud强制username字段要保持唯一性,所以此处用identifier赋值
            // 用户的自定义用户名后期考虑用其他字段保存,比如 displayName
            user.username = LCString(self.email)
            user.password = LCString(self.password)
            
            //            try user.set("appleUserIdentifier", value: identifier)
            try user.set("displayName", value: self.email)
            try user.set("email", value: self.email)
            
            //新建 LCUser 的操作应使用 signUp 而不是 save，但以后的更新操作就可以用 save 了。
            _ = user.signUp { (result) in
                self.isLoading = false
                switch result {
                    case .success:
                        print("signup 成功:", user)
                        self.isSuccessful = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isSuccessful = false
                            self.resetLogin()
                            self.isSignUp = false
                        }
                        break
                    case .failure(error: let error):
                        if error.code == 202 {
                            self.alertMessage = error.description
                            self.showAlert = true
                    }
                    
                }
            }
            
        } catch {
            print(error)
        }
    }
    func resetLogin(){
        self.email = ""
        self.password = ""
    }
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ZStack(alignment: .top) {
                Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .edgesIgnoringSafeArea(.bottom)
                CoverView()
                VStack {
                    Spacer()
                    HStack{
                        if !isSignUp {
                            VStack{ // 登录
                                HStack {
                                    TextField("Email", text: $email)
                                        .keyboardType(.emailAddress)
                                        .font(.subheadline)
                                        //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.leading)
                                        .frame(height: 44)
                                        .onTapGesture {
                                            self.isFocused = true
                                    }
                                }
                                Divider()
                                HStack {
                                    SecureField("Password", text: $password)
                                        .keyboardType(.emailAddress)
                                        .font(.subheadline)
                                        .padding(.leading)
                                        .frame(height: 44)
                                        .onTapGesture {
                                            self.isFocused = true
                                    }
                                }
                            }
                            .padding()
                            .animation(.easeIn)
                        } else {
                            VStack{ // 注册
                                HStack {
                                    TextField("手机号(测试期间直接输入邮箱接口)", text: $email)
                                        .keyboardType(.emailAddress)
                                        .font(.subheadline)
                                        //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.leading)
                                        .frame(height: 44)
                                        .onTapGesture {
                                            self.isFocused = true
                                    }
                                }
                                Divider()
                                HStack {
                                    TextField("验证码(测试期间不需要)", text: $email)
                                        .keyboardType(.emailAddress)
                                        .font(.subheadline)
                                        //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.leading)
                                        .frame(height: 44)
                                        .onTapGesture {
                                            self.isFocused = true
                                    }
                                }
                                Divider()
                                HStack {
                                    SecureField("密码", text: $password)
                                        .keyboardType(.emailAddress)
                                        .font(.subheadline)
                                        .padding(.leading)
                                        .frame(height: 44)
                                        .onTapGesture {
                                            self.isFocused = true
                                    }
                                }
                            }
                            .padding()
                            .animation(.easeOut)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 26, style:.continuous))
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                    .padding(.horizontal, 36)
                    
                    VStack {
                        Text(isSignUp ? "有账号,去登陆→" : "没有账号? 先去创建 →").font(.body).padding()
                            .onTapGesture {
                                self.isSignUp = !self.isSignUp
                        }
                        Button(action: {
                            if self.isSignUp {
                                self.signup()
                            } else {
                                self.login()
                            }
                        }) {
                            Text(self.isSignUp ? "Sign up" : "Log in").foregroundColor(.white)
                        }
                        .padding(12)
                        .padding(.horizontal, 30)
                        .background(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 20)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Error"), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                            }.frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth:.infinity, alignment: .bottom)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
            }
            .offset(y: isFocused ? -300 : 0) // 呼出键盘,向上抬起
            .animation(.easeInOut)
            .onTapGesture {
                self.isFocused = false
                self.isSuccessful = false
                self.hideKeyboard()
            }
            if isLoading {
                LoadingView()
            }
            if isSuccessful {
                SuccessView(text: self.isSignUp ? "注册中..." : "登录中...")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
//            .previewDevice("iPhone X")
    }
}

struct CoverView: View {
    var body: some View {
        VStack{
            // 几何尺寸输入
            // geometry.size.width 默认是屏幕宽度, 如果添加了padding,则为实际内容宽度
            GeometryReader { geometry in
                Text("畅所欲言")
                    .font(.system(size: geometry.size.width/10, weight:.bold, design: Font.Design.default))
            }
                .frame(maxWidth: 375, maxHeight: 100) // 设置为375, 而不是.infinity,是为了防止在ipad上字体边的太大
                .padding(.horizontal, 16) // 375(屏幕宽度) - (16*2) = 343, 上面geometry.size.width 则为343
            
            Text("和畅所欲言的人畅所欲言")
                .font(.subheadline)
                .frame(width: 250)
            
            CartoonView()
            
            Spacer()
        }
        .foregroundColor(Color.white)
        .padding(.top, 80)
        .frame(height: 477)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .multilineTextAlignment(.center)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}
