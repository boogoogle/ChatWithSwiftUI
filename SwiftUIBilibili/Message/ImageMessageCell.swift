//
//  ImageMessageCell.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/24/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import URLImage
import LeanCloud

struct ImageMessageCell: View {
    var message: IMImageMessage
    
    var body: some View {
        HStack{
            URLImage(
                message.url!,
                processors: [ Resize(size: CGSize(width: 100.0, height: 100.0), scale: UIScreen.main.scale) ],
                content: {
                    $0.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }).frame(width: 100.0,height: 100.0)
        }
        
    }
}

//struct ImageMessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageMessageCell()
//    }
//}
