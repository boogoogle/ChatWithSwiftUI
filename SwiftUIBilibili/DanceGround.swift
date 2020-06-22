//
//  DanceGround.swift
//  Ipadyou
//
//  Created by boo on 5/6/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import LeanCloud

struct DanceGround: View {
    @State var show = false
    @State var viewState = CGSize.zero // CG -> Core Graphics
    
    var body: some View {
        ZStack {
            TitleView()
            
            DanceGroundBottomCardView()
            
            CardView()
                .offset(x: 0, y: -40)
                .scaleEffect(0.85)
                .rotationEffect(Angle(degrees: 15.0))
                .rotation3DEffect(Angle(degrees: 50), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.darken)
            CardView()
                .offset(x: 0, y: -20)
                .scaleEffect(0.9)
                .rotationEffect(Angle(degrees: 10))
                .rotation3DEffect(Angle(degrees: 40), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.darken)
                
            CertificateView()
                .offset(x: viewState.width, y: viewState.height)
                .scaleEffect(0.95)
                .rotationEffect(Angle(degrees: show ? 5 : 0))
                .rotation3DEffect(Angle(degrees: show ? 30 : 0), axis: (x: 10.0, y: 10.0, z: 10.0))
                .blendMode(.darken)
                .animation(.default) // .spring()
                .onTapGesture {
                    self.show.toggle()
                }
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            self.viewState = value.translation
                        })
                        .onEnded({ value in
                            self.viewState = CGSize.zero
//                            self.show = false
                        })
                )
        }
    }
}

struct DanceGround_Previews: PreviewProvider {
    static var previews: some View {
        DanceGround()
    }
}

struct CardView: View {
    var body: some View {
        VStack(){
            Text("Card Back")
        }
        .frame(width: 300.0, height: 220.0)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

struct CertificateView: View {
    var body: some View {
        VStack() {
            HStack {
                VStack(alignment: .leading) {
                    Text("People are dancing!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                    Text("What was discussing?")
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding(8.0)
                .frame(width: 320.0,height: 220.0)
                .background(Color.black)
                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                .shadow(radius: 8.0)
            }
        }
    }
}

struct TitleView: View {
    var body: some View {
        VStack{
            Text("Cettificates")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Spacer()
        }
    }
}


