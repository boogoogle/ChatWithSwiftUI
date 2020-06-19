//
//  CartoonView.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/17/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct CartoonView: View {
    var body: some View {
        LottieView(filename: "picksome").frame(width: 200, height: 200)
    }
}

struct CartoonView_Previews: PreviewProvider {
    static var previews: some View {
        CartoonView()
    }
}
