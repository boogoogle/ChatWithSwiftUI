//
//  LCRest.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/23/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftyJSON

/**
      使用LeanCloud提供的rest接口获取数据
        接口返回数据的格式和sdk中的IMMessage不一样,需要自己重新定义
 */
struct LCRest {
    // 针对DanceGround页面中的聊天卡片,因为数据结构不一样,所以特殊处理一下
    public static func getConversationHistoryById(
        id: String,
        params: Dictionary<String, String>?,
        callback: @escaping (_ result : [MessageFromConvHistoryModel]) -> ()
    ){
        let url = "/1.2/rtm/conversations/\(id)/messages"
        let params = params ?? ["limit":"5"]
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
                var lcType: Int = -1
                var lcText = ""
                var imgUrl = ""
                
                if let dataRawValue = withJson["data"].rawValue as? String {
                    let dataJ = JSON(parseJSON: dataRawValue)
                    lcText = dataJ["_lctext"].string ?? ""
                    lcType = dataJ["_lctype"].int ?? -1
                    
                    // 处理图片消息
                    if lcType == -2 {
                        let lcfileDataJ = dataJ["_lcfile"]
                        imgUrl = lcfileDataJ["url"].string ?? ""
                    }
                    
                }
                return MessageFromConvHistoryModel(msgId: msgId, convId: convId, timestamp: timestamp, lcText: lcText,from:from, imgUrl: imgUrl, lcType: lcType)
            }
            
            for (_,subJson):(String, JSON) in json {
                list.append(resolveD(subJson))
            }
            callback(list)
        })
    }
}
