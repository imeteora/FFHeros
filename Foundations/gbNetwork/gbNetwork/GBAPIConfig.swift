//
//  gbApiConfig.swift
//  gbNetwork
//
//  Created by ZhuDelun on 2018/6/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

@objcMembers
public class GBAPIConfig: NSObject {
    public enum APIRequestMethod: Int32 {
        case GET = 0
        case POST
        case PUT
        case DELETE
    }

    public enum APISignType: Int32 {
        case None
        case Client
        case Server
    }

    var baseURL: String
    var method: APIRequestMethod
    var signType: APISignType
    var signKey: String
    fileprivate var _timeOut: TimeInterval
    var timeout: TimeInterval {
        get {

            return _timeOut
        }
        set {
            if newValue <= 0 {
                _timeOut = 30
            } else {
                _timeOut = newValue
            }
        }
    }
    var params: [String: String]?
    var extHttpHeader: [String: String]?
    var modelDescriptions: [GBAPIModelDescription]?

    override init() {
        self.baseURL = ""
        self._timeOut = 30
        self.method = .GET
        self.signType = .None
        self.signKey = ""
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
