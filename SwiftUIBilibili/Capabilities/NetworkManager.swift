//
//  NetworkManager.swift
//  Doctor
//
//  Created by xdw on 2019/12/26.
//  Copyright © 2019 xdw. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import CommonCrypto

enum MethodType {
    case get
    case post
}

let API_DOMAIN = "https://fnjukhqv.lc-cn-n1-shared.com"

struct NetworkManager {
    
    public static func requestData(_ type : MethodType, urlString : String, parameters : [String : Any]? = nil, finishedCallback : @escaping(_ result : String) -> ()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        let json: JSON = JSON(parameters ?? [:])
        
        dPrint(json);
        
        let header:HTTPHeaders = self.setHttpHeader()
        
        dPrint("header = ", header)
        
        let urlStr = API_DOMAIN + urlString
    
        dPrint("urlStr = ", urlStr)

        AF.request(urlStr,
                   method: method,
                   parameters: json,
            encoder:method == .get ? URLEncodedFormParameterEncoder.default : JSONParameterEncoder.default,
                   headers: header,
                   interceptor: nil
        ).responseString { (response) in
                guard let result = response.value else {
                    print(response.error ?? "错误为空")
                    return;
                }
            finishedCallback(result ) //  result 是 String
        };
        
    }
}


extension String {
    func hmac(by algorithm: Algorithm, key: [UInt8]) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: algorithm.digestLength())
        CCHmac(algorithm.algorithm(), key, key.count, self.bytes, self.bytes.count, &result)
        return result
    }
    
    func hashHex(by algorithm: Algorithm) -> String {
        return algorithm.hash(string: self).hexString
    }
    
    func hash(by algorithm: Algorithm) -> [UInt8] {
        return algorithm.hash(string: self)
    }
}


enum Algorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func algorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:    result = kCCHmacAlgMD5
        case .SHA1:   result = kCCHmacAlgSHA1
        case .SHA224: result = kCCHmacAlgSHA224
        case .SHA256: result = kCCHmacAlgSHA256
        case .SHA384: result = kCCHmacAlgSHA384
        case .SHA512: result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:    result = CC_MD5_DIGEST_LENGTH
        case .SHA1:   result = CC_SHA1_DIGEST_LENGTH
        case .SHA224: result = CC_SHA224_DIGEST_LENGTH
        case .SHA256: result = CC_SHA256_DIGEST_LENGTH
        case .SHA384: result = CC_SHA384_DIGEST_LENGTH
        case .SHA512: result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    func hash(string: String) -> [UInt8] {
        var hash = [UInt8](repeating: 0, count: self.digestLength())
        switch self {
        case .MD5:    CC_MD5(   string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA1:   CC_SHA1(  string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA224: CC_SHA224(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA256: CC_SHA256(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA384: CC_SHA384(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA512: CC_SHA512(string.bytes, CC_LONG(string.bytes.count), &hash)
        }
        return hash
    }
}

extension Array where Element == UInt8 {
    var hexString: String {
        return self.reduce(""){$0 + String(format: "%02x", $1)}
    }
    
    var base64String: String {
        return self.data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength76Characters)
    }
    
    var data: Data {
        return Data(self)
    }
}

extension String {
    var bytes: [UInt8] {
        return [UInt8](self.utf8)
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}





extension NetworkManager {
    static func setHttpHeader() -> HTTPHeaders {
        let timestampInterval: TimeInterval = Date().timeIntervalSince1970
        let timestamp = "\(Int(timestampInterval))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let headerParams: HTTPHeaders = [
            "X-LC-Id":"fnjUKhQvsD8oFXSvwk76BeBM-gzGzoHsz",
            "X-LC-Key":"gK044vy1Cj2mwwJ6Gaaa2UW0,master",
            "Content-Type":"application/json"]
        
//        dPrint("headerParams==", headerParams)
        return headerParams
        
    }
}

extension Dictionary {
    var jsonStr: String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = String(data: data!, encoding: .utf8)
        return jsonStr!
    }
}


extension String {
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
}
