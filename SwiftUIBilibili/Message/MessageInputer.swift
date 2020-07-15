//
//  MessageInputer.swift
//  Ipadyou
//
//  Created by boo on 5/7/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

//protocol MessageInputerDelegate: View{
//
//    func messageInputer(didFinishInput message: IMMessage)
//}

struct MessageInputer: View {
    var conversation: IMConversation!
    @Binding var textMessage: String
    @Binding var isFocus: Bool
    @EnvironmentObject private var conversationDetailData: ConversationDetailData
    @State var showImagePicker = false
    @State var image: UIImage? = nil
    
    
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
                        mainQueueExecuting {
                            self.conversationDetailData.messages.append(message)
                        }
                    case .failure(error: let error):
                            dPrint(error)
                }
            })
        } catch {
            dPrint(error)
        }
    }
    
    func uploadImage(){
//        do {
//            if let imageFilePath = Bundle.main.url(forResource: "image", withExtension: "jpg")?.path {
//                let imageMessage = IMImageMessage(filePath: imageFilePath, format: "jpg")
//                try LCClient.currentConversation.send(message: imageMessage, completion: { (result) in
//                    switch result {
//                        case .success:
//                            break
//                        case .failure(error: let error):
//                            print(error)
//                    }
//                })
//            }
//        } catch {
//            print(error)
//        }
    }
    var body: some View {
        VStack {
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
        }
    }
}
