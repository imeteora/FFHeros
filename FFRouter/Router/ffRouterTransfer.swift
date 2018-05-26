//
//  ffRouterTransfer.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/26.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

protocol ffRouterTransferProtocol {
    func tryTransferUrl(_ url:String!) -> String!;
}

@objc
class ffRouterTransfer: NSObject
{
    var acceptHosts: [String] = []
    var acceptScheme: [String] = []
    private var allRouterTransfer: [String: ffRouterTransferProtocol] = [:]

    public static let shared: ffRouterTransfer = {
        let _instance: ffRouterTransfer = ffRouterTransfer()
        return _instance
    }()


    required override init() {
        acceptScheme = ["http", "https"]
    }

    deinit {
        self.allRouterTransfer.removeAll()
        self.acceptHosts.removeAll()
    }

    public func registerTransfer(_ domain: String!, transfer: ffRouterTransferProtocol) {
        self.registerTransfer(domain, transfer: transfer, forceReplace: true)
    }

    public func registerTransfer(_ domain: String!, transfer: ffRouterTransferProtocol, forceReplace: Bool = false) {
        let alreadyHasOne: Bool  = allRouterTransfer.contains { (key:String, _) -> Bool in
            return (key == domain)
        }
        
        if alreadyHasOne == true && forceReplace == false {
            return
        }
        allRouterTransfer[domain] = transfer;
    }

    public func processUrl(_ url: String!, animted:Bool) -> String!
    {
        let _url: URL? = URL.init(string: url)
        if _url == nil {
            return url
        }
        if self.acceptScheme.contains((_url?.scheme!)!) == false {
            return url
        }

        var matchOneHost: Bool = false
        for (_, eachAcceptHost) in self.acceptHosts.enumerated() {
            matchOneHost = self.matchUrl(eachAcceptHost, url:_url?.host)
            if matchOneHost {
                break;
            }
        }

        if (matchOneHost == false) {
            return url
        }

        return url
    }


    /// 判断url是否符合所期望域名的格式匹配
    ///
    /// - Parameters:
    ///   - base: 期望的host格式
    ///   - url: 被检查的url链接
    /// - Returns: 返回true表示符合所期望的格式，否则不匹配
    private func matchUrl(_ base: String!, url: String!) -> Bool {
        let baseArray: [String] = base.components(separatedBy: ".")
        let urlArray: [String] = url.components(separatedBy: ".")
        if baseArray.count != urlArray.count {
            return false
        }

        var result = true
        for (idx, each_base) in baseArray.enumerated() {
            if each_base == "*" {
                continue
            }
            if each_base.elementsEqual(urlArray[idx]) == false {
                result = false
                break;
            }
        }
        return result
    }
}
