//
//  LoadingView.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/17/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        LottieView(filename: "loading").frame(width: 200, height: 200)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
