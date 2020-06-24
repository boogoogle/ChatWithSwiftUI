//
//  LCRest.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/23/20.
//  Copyright © 2020 boo. All rights reserved.
//

//import Foundation
import SwiftyJSON


struct LCRest {
    public static func getConversationHistoryById(id: String, callback: @escaping (_ result : [MessageFromConvHistoryModel]) -> ()){
        let url = "/1.2/rtm/conversations/\(id)/messages"
        let params = ["limit":"5"]
        NetworkManager.requestData(.get, urlString: url,parameters: params, finishedCallback: { (data:String) in
//            dPrint("jsonBefore",data)
            
            let json = JSON(parseJSON: data)
//            dPrint("jsonAfter",json[3]["data"], json[3]["data"]["_lctext"])
            
//            let jdjson = JSON(parseJSON: json[3]["data"].rawValue as! String)
//            dPrint("jsonAfter", jdjson["_lctext"])
            
            var list = [MessageFromConvHistoryModel]()
            func resolveD(_ withJson: JSON) -> MessageFromConvHistoryModel{
                let msgId = withJson["msg-id"].string ?? ""
                let convId = withJson["conv-id"].string ?? ""
                let timestamp = withJson["timestamp"].string ?? ""
                let from = withJson["from"].string ?? ""
                
                let dataJ = JSON(parseJSON: withJson["data"].rawValue as! String)
                let lcText = dataJ["_lctext"].string ?? ""
                
                return MessageFromConvHistoryModel(msgId: msgId, convId: convId, timestamp: timestamp, lcText: lcText,from:from)
            }
            
            for (_,subJson):(String, JSON) in json {
                list.append(resolveD(subJson))
            }
            callback(list)
        })
    }
}
