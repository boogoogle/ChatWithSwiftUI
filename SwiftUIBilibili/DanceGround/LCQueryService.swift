//
//  LCQueryService.swift
//  SwiftUIBilibili
//
//  Created by Boo on 7/3/20.
//  Copyright © 2020 boo. All rights reserved.
//
import LeanCloud

struct LCQueryService {
    public static var conversationQuery = LCQuery(className: "_Conversation")
    
    public static func getConversations(
        _ params: Dictionary<String, Any>?,
        _ callback: @escaping(_ result: [LCObject]) -> ()
    ){
        _ = self.conversationQuery.find{result in
            switch result {
                case .success(objects: let convObjList):
                    callback(convObjList)
                case .failure(error: let error):
                    print(error)
            }
        }
    }
}
