//
//  ViewExtensions.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/15/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

extension View {
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(
            isShowing: isShowing,
            presenting: {self},
            text: text
        )
    }
}
