//
//  ArbitraryMessageView.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/23/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct ArbitraryMessageView: View {
    @State var groupUserIds = Set<String>()
    @State var textMessage = "Hi"
    @State var isFocus: Bool = false
    @State var showImagePicker = false
    @State var image: UIImage? = nil
    @State var conversation: IMConversation!
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if image != nil {
                    Image(uiImage: image!).resizable().frame(width:100, height:100)
                }
                HStack {
                    TextField("Say Hi", text: $textMessage)
                        .padding(.leading, 5.0)
                        .frame(height: 40.0)
                        .foregroundColor(Color.green)
                        .onTapGesture {
                            self.isFocus = true
                    }
                    Button(action: {
                        self.hideKeyboard()
                        self.ensure()
                        self.isFocus = false
                        self.image = nil
                    }) {
                        Text("Send")
                    }
                    .padding(.horizontal, 8.0)
                    .frame(height: 40.0)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    
                    Button(action: {
                        self.isFocus = false
                        self.hideKeyboard()
                        self.showImagePicker = true
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    
                }
                .padding(8.0)
                .sheet(isPresented: $showImagePicker){
                    ImagePicker(sourceType: .photoLibrary) { image in
                        self.image = image
                        self.showImagePicker = false
                    }
                }
                .navigationBarTitle("随便说一句,给随便几个人", displayMode: .inline)    
            }.onAppear{
                self.initConvGroup()
            }
        }
    }
    
    //
    func initConvGroup(){
        // 随机找 10(或者更多) 在线的人组成群聊,发消息
        
        let query = LCQuery(className: "_User")
        query.limit = 3 // 先写2, 以后可以改成10or 更多
        _ = query.find{ result in
            switch result {
                case .success(objects: let users):
                    users.forEach{ obj in
                        let userIdenfify = obj.email!.stringValue!
                        self.groupUserIds.insert(userIdenfify)
                    }
                    self.createConvGroup()
                    break
                case .failure(error: let error):
                    dPrint(error)
            }
        }
    }
    
    func createConvGroup(){
        let me =  LCApplication.default.currentUser?.email?.stringValue
        do {
            try LCClient.currentIMClient.createConversation(clientIDs: self.groupUserIds, name: "\(me!)丢出的随便消息", isUnique: true, completion: { (result) in
                switch result {
                    case .success(value: let conversation):
                        self.conversation = conversation
                    case .failure(error: let error):
                        print(error)
                }
            })
        } catch {
            print(error)
        }
    }
    
    func hideKeyboard(){
        /**
         通过将target设置为nil，让系统自动遍历响应链
         从而响应链当前第一响应者响应我们自定义的方法"
         */
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func ensure(){
        if(self.image != nil) {
            //            let imageUrl = uploadImage()
            if  let jpegData = image?.jpegData(compressionQuality: 1.0){
                let file = LCFile(payload: .data(data: jpegData))
                
                _ = file.save{ result in
                    switch result {
                        case .success:
                            if let imageLCUrl = file.url?.value {
                                if let url = URL(string: imageLCUrl) {
                                    let imImageMessage = IMImageMessage(url: url)
                                    self.send(message: imImageMessage)
                                }
                        }
                        case .failure(error: let error):
                            print(error, "pic save error")
                    }
                }
            }
        } else {
            print(self.$textMessage)
            let imTextMessage = IMTextMessage(text: self.textMessage)
            self.send(message: imTextMessage)
        }
    }
    
    func send(message: IMMessage) {
        do {
            try self.conversation.send(message: message, completion: { (result) in
                switch result {
                    case .success:
                        dPrint("send \(self.groupUserIds)---success")
                    case .failure(error: let error):
                        dPrint(error)
                }
            })
        } catch {
            dPrint(error)
        }
    }
}

struct ArbitraryMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ArbitraryMessageView()
    }
}
