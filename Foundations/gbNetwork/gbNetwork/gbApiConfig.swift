//
//  gbApiConfig.swift
//  gbNetwork
//
//  Created by ZhuDelun on 2018/6/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

@objcMembers
class gbApiConfig: NSObject
{
    public enum APIRequestMethod : Int32 {
        case GET = 0
        case POST
        case PUT
        case DELETE
    }

    public enum APISignType : Int32 {
        case None
        case Client
        case Server
    }

    var baseURL:String! = ""
    var method: APIRequestMethod = .GET
    var signType: APISignType = .None
    var signKey: String?
    var timeout: TimeInterval = 30
    var params: [String: String] = [:]
    var extHttpHeader: [String: String]?
    var modelDescriptions: [gbAPIModelDescription]?

    override init() {
    }

    public func authSignStringOfRequest() -> String? {
        return nil
    }

    public func authSignDictOfRequest() -> [String: String]? {
        return nil
    }

    public func getFinalParameter() -> [String: String] {
        return [:]
    }

    fileprivate func ts() -> String! {
        return ""
    }
}
