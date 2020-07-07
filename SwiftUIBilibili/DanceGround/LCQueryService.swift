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
        _ params: Dictionary<String, LCValue>?,
        _ callback: @escaping(_ result: [LCObject]) -> ()
    ){
        self.conversationQuery.whereKey("createdAt", .descending)// 降序排列
        
        
        if let limit = params?["limit"] {
            self.conversationQuery.limit = limit.intValue
        } else {
            self.conversationQuery.limit =  2
        }
        
        if let lastConvCreatedAt = params?["lastConvCreatedAt"] {
            self.conversationQuery.whereKey("createdAt", .lessThan(lastConvCreatedAt as! LCDate))
        }
        
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
