//
//  DanceGroundData.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/23/20.
//  Copyright © 2020 boo. All rights reserved.
//

import Combine
import SwiftUI
import LeanCloud

final class DanceGroundData: ObservableObject {
//    @Published var convHistoryGroup = [String: [IMMessage]]()
    @Published var convHistoryGroup = [[MessageFromConvHistoryModel]]()
}
