//
//  Toast.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/15/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct Toast<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    
    // the view that will be presenting in this toast
    let presenting: () -> Presenting
    let text: Text
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()
                    .blur(radius: self.isShowing ? 1: 0)
                
                if self.isShowing {
                    VStack {
                        self.text
                    }
                        //                .frame(width: geometry.size.width / 2,
                        //                        height: geometry.size.height / 5)
                        .padding()
                        .background(Color.secondary.colorInvert())
                        .foregroundColor(Color.primary)
                        .cornerRadius(20)
                        .transition(.slide)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.isShowing = false
                                print("dispearrrr")
                            }
                    }
                    .opacity(self.isShowing ? 1 : 0)
                }
            }.onTapGesture {
                self.isShowing = false
            }
        }
    }
}
